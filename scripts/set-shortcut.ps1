param (
  [parameter(Mandatory=$true)]
  [ValidateScript({Test-Path $_})]
  [string]$SourceExecutable,
  [parameter(Mandatory=$true)]
  [ValidateScript({Test-Path $_ -PathType 'Container'})] 
  [string]$TargetFolder,
  [parameter(ValueFromRemainingArguments = $true)]
  [string]$Arguments
)

$LinkName = [io.path]::GetFileNameWithoutExtension($SourceExecutable)
$TargetLink = Join-Path $TargetFolder ($LinkName + ".lnk")

Write-Host "Creating link $TargetLink to $SourceExecutable with arguments $Arguments"

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($TargetLink)
$Shortcut.TargetPath = $SourceExecutable
$Shortcut.Arguments = $Arguments
$Shortcut.Save()