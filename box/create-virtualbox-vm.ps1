$ScriptName = $MyInvocation.MyCommand.Name

if ($args.Count -ne 1 -or -not(Test-Path $args[0]))
{
  Write-Host "Usage: $ScriptName source_vhd_file_path" -ForegroundColor Green
  Exit
}

$SourceVhd = Resolve-Path $args[0]
$OriginalName = [io.path]::GetFileNameWithoutExtension($SourceVhd)
$TargetName = "$OriginalName.$pid"
$TargetVhd = "./$TargetName.vhd"

if (Test-Path $TargetVhd)
{
  Write-Host "Target VHD $TargetVhd already exists and it won't be copied again"
}
else
{
  Write-Host "Copying $SourceVhd to $TargetVhd, depending on the size this may take a while"
  Copy-item $SourceVhd -destination $TargetVhd -Verbose
}

Write-Host "Creating VirtualBox VM"

$vboxmanage = "VBoxManage.exe"

& $vboxmanage createvm --name $TargetName --register
& $vboxmanage modifyvm $TargetName --ostype Windows2008_64
& $vboxmanage modifyvm $TargetName --memory 2048 --vram 64 --cpus 2 --pae on --ioapic on --hwvirtex on --acpi on --boot1 disk
& $vboxmanage modifyvm $TargetName --nic1 nat --nictype1 82545EM
& $vboxmanage modifyvm $TargetName --audio none --usb on --usbehci on
& $vboxmanage modifyvm $TargetName --clipboard bidirectional --draganddrop disabled
& $vboxmanage modifyvm $TargetName --vrde off
 
& $vboxmanage storagectl $TargetName --name "IDE Controller" --add ide
& $vboxmanage storageattach $TargetName --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium $TargetVhd
& $vboxmanage storageattach $TargetName --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium emptydrive
 
& $vboxmanage startvm $TargetName