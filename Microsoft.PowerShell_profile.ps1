# Force l'encode des caractères en UTF8 
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

# Alias 
set-alias -name "dig" -Value "Resolve-DnsName"

# Shows navigable menu of all options when hitting Tab
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Autocompletion for arrow keys
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
