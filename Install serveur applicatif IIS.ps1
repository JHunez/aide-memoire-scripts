<#
Ce script automatise la configuration de serveur IIS pour des applications spécifique. 

Cela passe par l'ajout d'user AD dans des groupes locaux, l'ajout de certificats PFX et la creation du service lié l'application.
L'installation du rôle IIS en lui mêm est géré par un autre script appelé ici.
#>

#Ajout des users requis en tant qu'admins locaux du serveur
$Users = @("CUST/UserAppli", "INFRA/UserAppli2")
$LocalGroup = "UnGroupeSecret"
$Computer   = $env:computername

foreach ($user in $Users ) {
([ADSI]"WinNT://$Computer/$LocalGroup,group").psbase.Invoke("Add",([ADSI]"WinNT://$User").path)
}



#copie des modules Powershell s'ils n'existent pas depuis un serveur IIS "serveuriis" existant et fonctionnel
if( -not (Test-Path -Path c:\Windows\System32\WindowsPowerShell\v1.0\Modules\CEGIDEventLog ))
{
    Copy-Item \\serveuriis\c$\Windows\System32\WindowsPowerShell\v1.0\Modules\CEGIDEventLog -Destination C:\Windows\System32\WindowsPowerShell\v1.0\Modules\ -Recurse
}

if( -not (Test-Path -Path c:\Windows\SysWOW64\WindowsPowerShell\v1.0\Modules\CEGID* ))
{
	Copy-Item \\serveuriis\c$\Windows\SysWOW64\WindowsPowerShell\v1.0\Modules\CEGIDEventLog -Destination C:\Windows\SysWOW64\WindowsPowerShell\v1.0\Modules\ -Recurse
}

#Copie du script d'installation et des dossiers utiles au script
if( -not (Test-Path -Path "C:\Logiciels\iissetup Install-CEGIDIISPlateform.ps1" ))
{
	robocopy.exe \\serveurftp\Logiciels\Distribution\Microsoft\IISSetup C:\Logiciels /s 
}
  
Powershell C:\Logiciels\ScriptIntallIIS.ps1 


robocopy "\\serveuriis\l$" "L:" /e /xf *
robocopy "\\serveuriis\c$\Logiciels" "C:\Logiciels" "certificat.pfx" /MIR

robocopy "\\serveuriis\c$\Logiciels\Soft" "C:\Logiciels\Soft" /MIR
robocopy "\\serveuriis\c$\Program Files\Soft2" "C:\Program Files\Soft2" /MIR

<#
L'import du certificat Pfx ne fonctionne pas. à débug : Import-PfxCertificate : Accès refusé. 0x80070005 (WIN32: 5 ERROR_ACCESS_DENIED)
$certifPwd = Read-host "Entrez le mot de passe du certificat"
$certifPwd = ConvertTo-SecureString -String $certifPwd -Force –AsPlainText
Import-PfxCertificate -Exportable -Password $certifPwd -CertStoreLocation Cert:\LocalMachine\My -FilePath C:\Logiciels\certificat.pfx
#>

#cretion du service.
New-Service Cegid.Dsn.Link.Sheik-production -BinaryPathName "C:\Program Files\CegidDsnLink\Soft\production\Soft.Service.exe" -DisplayName "Soft.Service" -StartupType Automatic
Get-Service -Name Cegid.Dsn.Link.Sheik-production | Start-Service
