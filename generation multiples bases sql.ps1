<#
Script générant les commandes sql pour créer de plusieurs nouvelles base à partir de la base modèle Base_Modele.bak
D'autres requète sont passée pour rendre compatible la base à l'application en SaaS (gestion du Broker et du compte admin de la base)

Le fichier sql est composé des "n" requetes pour les n dossiers à créer. 

Les base sont nommée : sic_xxx. 
Exemple : sic_101, sic_310
#>

Param(
[int]$sic,
[int]$start,
[int]$finish
)


#récupére le nom de l'instance SQL sur le serveur 
$instance=(get-itemproperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server').InstalledInstances

#Génére le fichier sql query nommé suivant la date du jour et le code du client.
$Date = get-date
$date = $date.tostring("ddMMyyyy")
$query= " " | Out-File  -filepath C:\temp\query-$sic-$date.sql

for ( $start; $start -lt $finish; $start++) {

$startstrg = $start.ToString("000")
$db = -join("DSDFIN_", "$sic", "P_", "$startstrg")

$query= "
RESTORE DATABASE [$db] FILE = N'MODELE_Data' FROM  DISK = N'I:\Modele\Base_Modele.bak' WITH  FILE = 1,  MOVE N'MODELE_Data' TO N'I:\sqldata\$instance\$db.mdf',  MOVE N'MODELE_Log' TO N'I:\sqldata\$instance\$db.ldf',  NOUNLOAD,  STATS = 10
GO

ALTER DATABASE $db SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
ALTER DATABASE $db SET ENABLE_BROKER;
ALTER DATABASE $db SET DISABLE_BROKER;
ALTER DATABASE $db SET NEW_BROKER;
ALTER DATABASE $db SET MULTI_USER WITH ROLLBACK IMMEDIATE;
GO

USE [$db]
GO
CREATE USER [ADMIN_$sic] FOR LOGIN [ADMIN_$sic]
GO
USE [$db]
GO
ALTER ROLE [db_owner] ADD MEMBER [ADMIN_$sic]
GO
"
#ajout de la requete à la suite des précédentes. 
$query | Out-File  -filepath C:\Users\hunez\Desktop\query-$sic-$date.sql -Append
Write-Host $db
}