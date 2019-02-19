<#
Ce sript parcours l'AD et récupère les derniers serveurs d'une ferme de serveur SQL, compte le nombre d'instances SQL (qui équivaut au nombre de clients hébergés sur ce serveur) 
Il donne aussi l'espace libre et max du disque où sont stocké les bases. 

#>


$date=get-date
$startDate = ([datetime]$Date).Date
$endDate = $startDate.Addmonths(-4)
Clear Host
$sql=Get-ADComputer -Filter 'whenCreated -le $startDate -and whenCreated -gt $endDate -and name -like "*SQL*"' -SearchBase "OU=06,OU=SQL,OU=Serveurs,OU=Clichy-B03,OU=Ressources,DC=cust,DC=asp" -Server gina03.cust.asp | sort-object -Property Name
$buro =Get-ADComputer -Filter 'whenCreated -le $startDate -and whenCreated -gt $endDate -and name -like "*FIC*"' -SearchBase "OU=00,OU=FIC,OU=Serveurs,OU=Clichy-B03,OU=Ressources,DC=cust,DC=asp" -Server gina03.cust.asp | sort-object -Property Name


foreach ( $sqlserver in $sql )
{

$sqlserver=$sqlserver.name
$buroserver=$buroserver.name
#Vérif de l'espace disque restant sur D: avec WMI
        $drives=Get-WmiObject Win32_LogicalDisk -cn $sqlserver |  Where-Object { $_.DeviceId -eq 'I:'} 
        $EspaceLibre=[int]($drives.FreeSpace/1GB)
        $size=[int]($drives.size/1GB)
#Verifie le nombre de client sur le serveur en comptant les instances SQL
        
        $NbClient=Get-ChildItem -Directory -Path \\"$sqlserver"\i$\sqldata\ | where-object { $_.name -like "DSICEOD*"} | Measure-Object | %{$_.count}

        Write-Host "Il y a "$NbClient" clients sur "$sqlserver" et" $EspaceLibre"Go d'espace libre sur "$size"Go."
        Write-Host "Il reste sur "$buroserver" " $EspaceLibre"Go d'espace libre sur "$size"Go."
	
}





foreach ( $buroserver in $buro )
{

$buroserver=$buroserver.name
#Vérif de l'espace disque restant sur D: avec WMI
        $drives=Get-WmiObject Win32_LogicalDisk -cn $buroserver |  Where-Object { $_.DeviceId -eq 'I:'} 
        $EspaceLibre=[int]($drives.FreeSpace/1GB)
        $size=[int]($drives.size/1GB)
        Write-Host "Il reste sur le serveur de bureautique "$buroserver" " $EspaceLibre"Go d'espace libre sur "$size"Go."
	
}

pause
