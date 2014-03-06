$puppetUrl = "https://downloads.puppetlabs.com/windows/puppet-3.4.3.msi"

try {
  & puppet "--version"
  Write-Host "Puppet is already installed, remove it if you want to install it again"
} catch {
  Write-Host "Downloading and installing Puppet from $puppetUrl"
  $p = Start-Process msiexec.exe "/qn /norestart /i $puppetUrl  PUPPET_AGENT_STARTUP_MODE=Disabled" -Wait
  if ($p.ExitCode -ne 0) {
    Write-Host "Puppet installation failed with exit code $p.ExitCode" -foreground red
    Exit $p.ExitCode
  }
  Write-Host "Puppet has been installed"
}