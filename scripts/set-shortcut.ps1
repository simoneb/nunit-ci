param (
  [parameter(Mandatory=$true)]
  [ValidateScript({Test-Path $_})]
  [string]$SourceExecutable,
  [parameter(Mandatory=$true)]
  [string]$TargetLink,
  [parameter(ValueFromRemainingArguments = $true)]
  [string]$Arguments
)

Write-Host "Creating link $TargetLink to $SourceExecutable with arguments $Arguments"

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($TargetLink)
$Shortcut.TargetPath = $SourceExecutable
$Shortcut.Arguments = $Arguments
$Shortcut.Save()