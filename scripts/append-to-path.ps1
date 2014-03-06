param(
  [string]$pathToAppend
)

$envPath = $env:PATH
$terminator = ";"

if (!$envPath.ToLower().Contains($pathToAppend.ToLower())) {
  Write-Host "PATH environment variable does not have `'$pathToAppend`' in it, adding..."
  $actualPath = [Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine)
  $hasTerminator = $actualPath -ne $null -and $actualPath.EndsWith($terminator)
  if (!$hasTerminator -and $actualPath -ne $null) {
    $pathToAppend = $terminator + $pathToAppend
  }

  [Environment]::SetEnvironmentVariable('Path', $actualPath + $pathToAppend, [System.EnvironmentVariableTarget]::Machine)
}