<#le script désactive tous les users qui sont dans un groupe AD spécifique en laissant actif les comptes AD applicatifs
qxchange est un compte utilisé par l'appli et ne doit pas être désactivé
en cours de dev
#>

Param(
[Parameter(Mandatory=$true)][int]$sic,
[Parameter(Mandatory=$true)][string]$offre,
[string]$AD="adserv"
)

Import-Module -Name activedirectory 


Function disablegroupmember ($sic)
{
$qexch="qxchange-($sic)"
Get-ADGroupMember $group -server $AD | Where-Object {$_.Name -notcontains $qexch } | Get-ADUser -Property Name | Select Name,Enabled
pause
Get-ADGroupMember $group -server $AD | Where-Object {$_.Name -notcontains $qexch } | Disable-ADAccount
Write-Host 'Etat après modification :' 
Get-ADGroupMember $group -server $AD | Where-Object {$_.Name -notcontains $qexch } | Get-ADUser -Property Name | Select Name,Enabled
}



