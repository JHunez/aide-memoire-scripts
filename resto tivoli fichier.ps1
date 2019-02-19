<#
Tivoli, l'outil de backup IBM utilisé dans leurs datacenters fonctionne via un MMC et en Powershell.
La restauration de fichier nécessite de préciser le chemin précis du dossier à restaurer et une date de restauration.
Le chemin est déduit du code client et de l'offre (ici paie) 

On commence par renommer le dossiers actuel avant de le restaurer à un état précédent afin de pouvoir revenir en arrière le cas échéant.
puis on execute l'exe Tivoli en appliquant les bon paramètres.
#>

Param(
[Parameter(Mandatory=$true)][int]$sic,
[Parameter(Mandatory=$true)][string]$dossier,
[Parameter(Mandatory=$true)][string]$date
)

$pilote = "jh"
$sic=$sic.Trim()
$dossier=$dossier.Trim()


$timestamp=Get-Date
$timestamp=$timestamp.ToUniversalTime().tostring('ddMMyyyy')

<#Si la base à restaurer est utilisée, on ne pourra pas renommer le dossier. Cette étape vérifie si le fichier de base de données qpaie.mdb est locké. 
Si oui, il clos le partage et donc libère le fichier. 
#>

try {
$FileStream = [System.IO.File]::Open("D:\Qappli\Quadra\$sic\paie\$dossier\qpaie.mdb",'Open','Write')
$FileStream.Close()
$FileStream.Dispose()
}
Catch {
Get-SmbOpenFile | Where-Object { $_.Path -like "D:\Qappli\Quadra\$sic\paie\$dossier*"} | Close-SmbOpenFile -Force
}


#Le try permet de demaner à l'utilisateur de passer par le GUI si une errreur survient.

try {
Rename-Item -Path D:\Qappli\Quadra\$sic\paie\$dossier -NewName "$dossier.$timestamp.$pilote" 
$arg="res D:\Qappli\Quadra\$sic\paie\$dossier\ D:\Qappli\Quadra\$sic\paie\ -pitd=$date"
Start-Process -FilePath "C:\Program Files\Tivoli\TSM\baclient\dsmc.exe" -ArgumentList $arg -WorkingDirectory "C:\Program Files\Tivoli\tsm\baclient\"
}
Catch {
    "Merci de vérifier les dossiers et passer par l'interface graphique Tivoli"
    ii D:\Qappli\Quadra\$sic\paie\$dossier
    BREAK
}













<#
Param(
[Parameter(Mandatory=$true)][int]$sic,
[Parameter(Mandatory=$true)][string]$dossier,
[Parameter(Mandatory=$true)][string]$date
)
$pilote = "jh"
$sic=$sic.trim()

$timestamp=Get-Date
$timestamp=$timestamp.ToUniversalTime().tostring('ddMMyyyy')


$ErrorActionPreference = "stop"
try {
$FileStream = [System.IO.File]::Open("D:\Qappli\Quadra\$sic\paie\$dossier\qpaie.mdb",'Open','Write')
$FileStream.Close()
$FileStream.Dispose()
}
Catch {
#Get-SmbOpenFile | Where-Object { $_.Path -like "D:\Qappli\Quadra\$sic\paie\$dossier*"} | Close-SmbOpenFile -Force
Get-SmbOpenFile | Where-Object { $_.Path -like "D:\Qappli\Quadra\$sic\paie\$dossier*"}
}
if( Test-Path -Path D:\Qappli\Quadra\$sic\paie\$dossier )
{
Rename-Item -Path D:\Qappli\Quadra\$sic\paie\$dossier -NewName "$dossier.$timestamp.$pilote" 

$arg="res D:\Qappli\Quadra\$sic\paie\$dossier\ D:\Qappli\Quadra\$sic\paie\ -pitd=$date"
Start-Process -FilePath "C:\Program Files\Tivoli\TSM\baclient\dsmc.exe" -ArgumentList $arg -WorkingDirectory "C:\Program Files\Tivoli\tsm\baclient\"
}
#>