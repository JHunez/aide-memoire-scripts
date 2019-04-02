
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$Global:xmlWPF = Get-Content -Path C:\Scripts\gui\gui.xaml

#Read XAML
$reader=(New-Object System.Xml.XmlNodeReader $xaml)
try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
catch{Write-Host "Unable to load Windows.Markup.XamlReader"; exit}

# Store Form Objects In PowerShell
$xaml.SelectNodes("//*[@Name]") | ForEach-Object {Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)}



$Nom_TextBox.text = $env:COMPUTERNAME
$CPU_TextBox.text = $env:USERNAME
$RAM_TextBox.text = $env:USERDOMAIN

#Assign event
$Close_bouton.Add_Click({
    $form.Close()
})

#Show Form
$Form.ShowDialog() | out-null

