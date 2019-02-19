<# en cours de dev.
utilisation de la ligne de commande pour utiliser l'outil de back SQL IBM DPSQL
Tivoli DPSQL est un outil en cloud IBM qui gère le backup des bases sql.
Un GUI existe mais il dans le cas d'un serveur avec de nombreuses bases et instances, il est très lent.

#>

$arg="Backup-DpSqlComponent  DSDFIN_98579468P_003 -ConfigFile "C:\Program Files\Tivoli\TSM\TDPSql\tdpsql.cfg" -TsmOptFile "C:\Program Files\Tivoli\TSM\TDPSql\dsm.opt" -FULL -BackupDestination TSM -BackupMethod Legacy -SqlServer "S110762SQL010\DSIFIN_M0000010P,3950" -SQLAUTHentication INTegrated -SqlChecksum No -Stripes 1 -MountWait Yes"
Start-Process -FilePath "C:\Program Files\Tivoli\TSM\TDPSql\tdpsqlc.exe" -ArgumentList $arg -WorkingDirectory "C:\Program Files\Tivoli\TSM\TDPSql"
