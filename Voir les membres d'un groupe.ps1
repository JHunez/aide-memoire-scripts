Param(
[int]$sic,
[string]$offre
)

$sic = Read-host "Code Sic"

Import-Module -Name activedirectory 
Function SeeGroupMember ($group)
{Get-ADGroupMember $group -server $AD |  Get-ADUser -Property Name | Select Name,Enabled}

$AD="gina03.cust.asp"

# A refaire, bug dans menu.

function Show-Menu
{
     param (
           [string]$Title = 'My Menu'
     )
     cls
     Write-Host "================ $Title ================"
    
     Write-Host "1: Qeod."
     Write-Host "2: Ceod"
     Write-Host "3: Fiscaod"
     Write-Host "3: juriod"
     Write-Host "Q: Press 'Q' to quit."
}



do
{
     Show-Menu
     $input = Read-Host "Please make a selection"
     switch ($input)
     {
           '1' {
                cls
                'Utilisateurs Qeod'
                $qexch="qxchange-($sic)"
                Get-ADGroupMember $group -server $AD | Where-Object {$_.Name -notcontains $qexch } | Get-ADUser -Property Name | Select Name,Enabled
           } '2' {
                cls
                'Utilisateurs Ceod'
                $group=Get-ADGroup "grp$sic" -server $AD
                SeeGroupMember
           } '3' {
                cls
                'Utilisateurs Fiscaod'
                $group=Get-ADGroup "ufi$sic" -server $AD
                SeeGroupMember 
           } '4' {
                cls
                'Utilisateurs juriod'
                $group=Get-ADGroup "juri$sic" -server $AD
                SeeGroupMember
           } 
           
           
           'q' {
                return
           }
     }
     pause
}
until ($input -eq 'q')

            
