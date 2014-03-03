$client = new-object System.Net.WebClient
$buildAgent = Join-Path (Get-Location).Path "buildAgent"
$agentBat = Join-Path $buildAgent "bin\agent.bat"
$root = (Resolve-Path "\vagrant").Path
$downloads = Join-Path $root "downloads"
$javaUrl = "http://javadl.sun.com/webapps/download/AutoDL?BundleId=83385"
$javaInstaller = Join-Path $downloads "java-installer.exe"
$javaPath = Join-Path $env:ProgramFiles "Java\jre7"
$agentZipUrl = "http://192.168.30.10:8111/update/buildAgent.zip"
$agentZip = Join-Path $downloads "buildAgent.zip"

if ((Test-Path $agentBat) -and (Test-Path $javaPath))
{
  Write-Host "Build agent found, stopping"
  & $agentBat stop force
  Start-Sleep -s 5
}

if (Test-Path $javaInstaller)
{
  Write-Host "Java installer found in $javaInstaller, please delete it if you want to download it again"
}
else
{
  Write-Host "Downloading Java"
  $client.DownloadFile($javaUrl, $javaInstaller)
}

if(Test-Path $javaPath)
{
  Write-Host "Java seems to be already installed in $javaPath, please uninstall it if you want to install it again"
}
else
{
  Write-Host "Installing Java in $javaPath"
  & $javaInstaller /s /v"/qn INSTALLDIR=\""C:\Program Files\Java\jre7\"""
  Write-Host "Setting environment variable JRE_HOME to $javaPath"
  & "SETX" JRE_HOME "$javaPath"
  
  do
  {
    Write-Host "Waiting for Java to be installed in $javaPath"
    Start-Sleep -s 5
  }
  while (-not (Test-Path $javaPath))
}

if(Test-Path $agentZip)
{
  Write-Host "Agent zip already exists in $agentZip, delete it if you want to download it again"
}
else
{
  Write-Host "Downloading agent zip from $agentZipUrl into $agentZip"
  $client.DownloadFile($agentZipUrl, $agentZip)
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
& (Join-Path $root "scripts\set-shortcut.ps1") $agentBat "$env:appdata\Microsoft\Windows\Start Menu\Programs\Startup" start

Write-Host "Logon or logoff+logon to start agent" -ForegroundColor Green