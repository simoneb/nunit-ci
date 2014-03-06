$puppetUrl = "https://downloads.puppetlabs.com/windows/puppet-3.4.3.msi"
$puppetInstaller = "c:\vagrant\downloads\puppet-3.4.3.msi"

try {
  & puppet "--version"
  Write-Host "Puppet is already installed, remove it if you want to install it again"
} catch {
  if(-not (Test-Path $puppetInstaller))
  {
    Write-Host "Downloading Puppet from $puppetUrl"
    (new-object Net.WebClient).DownloadFile($puppetUrl, $puppetInstaller)
  }

  Write-Host "Installing Puppet from $puppetInstaller"

  $p = Start-Process msiexec.exe "/qn /norestart /i $puppetInstaller PUPPET_AGENT_STARTUP_MODE=Disabled" -Wait -PassThru

  if ($p.ExitCode -ne 0) {
    Write-Host "Puppet installation failed with exit code $p.ExitCode" -ForegroundColor Red
    Exit $p.ExitCode
  }

  Write-Host "Puppet has been installed"
}