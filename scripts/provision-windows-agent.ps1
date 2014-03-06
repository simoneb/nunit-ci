$buildAgent = Join-Path (Get-Location).Path "buildAgent"
$agentBat = Join-Path $buildAgent "bin\agent.bat"
$agentPort = Join-Path $buildAgent "logs\buildAgent.port"
$root = (Resolve-Path "\vagrant").Path
$agentZip = Join-Path $root "downloads\buildAgent.zip"

$shortcut = Join-Path $root "scripts\set-shortcut.ps1"

Write-Host "Beginning provisioning of TeamCity build agent"

if (Test-Path $agentPort)
{
  Write-Host "Build agent running, stopping"
  & $agentBat stop force
  Start-Sleep -s 5
}

if(-not (Test-Path $agentZip))
{
  Write-Host "Agent zip not found in $agentZip, installation cannot proceed"
  Exit 1
}

$shell=new-object -com shell.application

Write-Host "Removing directory structure $buildAgent"
cmd /C "rd /s /q $buildAgent"
cmd /C "mkdir $buildAgent"

Write-Host "Extracting $agentZip into $buildAgent"
$shell.namespace($buildAgent).Copyhere($shell.namespace($agentZip).items())

Write-Host "Copying configuration file over"
copy $root\config\buildAgent.windows.properties $buildAgent\conf\buildAgent.properties

Write-Host "Creating startup link"
& $shortcut $agentBat "$env:appdata\Microsoft\Windows\Start Menu\Programs\Startup\start-agent.lnk" start

Write-Host "Creating agent start and stop links on the Desktop"
& $shortcut $agentBat "$env:userprofile\Desktop\start-agent.lnk" start
& $shortcut $agentBat "$env:userprofile\Desktop\stop-agent.lnk" stop

Write-Host "Logon or logoff+logon to start agent" -ForegroundColor Green