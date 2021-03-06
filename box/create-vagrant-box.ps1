$baseName = (Get-Item *.vhd).BaseName
$boxName = "windows-server-2008-r2-eval"

Write-Host "Packaging box $baseName"
& "vagrant" package --base "$baseName" --output "$baseName.box"
Write-Host "Trying to remove existing box with the same name"
& "vagrant" box remove $boxName
Write-Host "Adding box $baseName to vagrant with name $boxName"
& "vagrant" box add $boxName "$baseName.box"
