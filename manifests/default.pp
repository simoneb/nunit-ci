$netcf20Url = "http://download.microsoft.com/download/0/7/2/0728de3a-fa75-413f-b3b6-8050518cef86/NETCFSetupv2.msi"
$netcf20Path = "c:\\vagrant\\downloads\\netcf20.msi"

$netcf35Url = "http://download.microsoft.com/download/c/b/e/cbe1c611-7f2f-4bcf-921d-2df718591e1e/NETCFSetupv35.msi"
$netcf35Path = "c:\\vagrant\\downloads\\netcf35.msi"

$netcf35PowerToysUrl = "http://download.microsoft.com/download/f/a/c/fac1342d-044d-4d88-ae97-d278ef697064/NETCFv35PowerToys.msi"
$netcf35PowerToysPath = "c:\\vagrant\\downloads\\netcf35PowerToys.msi"

$net40SDKUrl = "http://download.microsoft.com/download/F/1/0/F10113F5-B750-4969-A255-274341AC6BCE/GRMSDK_EN_DVD.iso "
$net40SDKIsoPath = "c:\\vagrant\\downloads\\net40SDK.iso"
$net40SDKExtractLocation = "c:\\vagrant\\downloads\\net40SDK"
$net40SDKInstaller = "c:\\vagrant\\downloads\\net40SDK\\setup.exe"

$net4SDKUrl = "http://www.microsoft.com/click/services/Redirect2.ashx?CR_EAC=300135395"
$net451SDKPath = "c:\\vagrant\\downloads\\net451SDK.exe"

$net451Url = "http://go.microsoft.com/fwlink/?LinkId=322116"
$net451Path = "c:\\vagrant\\downloads\\net451.exe"

$agentZipUrl = "http://audrey.xip.io/update/buildAgent.zip"
$agentZipPath = "c:\\vagrant\\downloads\\buildAgent.zip"

$appendPath = 'c:/vagrant/scripts/append-to-path.ps1'

exec { 'Open TeamCity agent port':
  command => 'netsh advfirewall firewall add rule name="Open Port 9090" dir=in action=allow protocol=TCP localport=9090',
  provider => powershell,
}

exec { 'GetAgentZip':
  command   => "curl.exe -L -o ${agentZipPath} ${agentZipUrl}",
  creates => $agentZipPath,
  provider  => powershell,
}

exec { 'Microsoft .NET Framework 3.5':
  command => "DISM /Online /NoRestart /Enable-Feature /FeatureName:NetFx3",
  provider => powershell,
}

exec { 'GetNetcf20':
  command   => "curl.exe -L -o ${netcf20Path} ${netcf20Url}",
  creates => $netcf20Path,
  provider  => powershell,
}
->
package { 'Microsoft .NET Compact Framework 2.0 SP2':
  ensure => installed,
  source => $netcf20Path,
}

exec { 'GetNetcf35':
  command   => "curl.exe -L -o ${netcf35Path} ${netcf35Url}",
  creates => $netcf35Path,
  provider  => powershell,
}
->
package { 'Microsoft .NET Compact Framework 3.5':
  ensure => installed,
  source => $netcf35Path,
}

exec { 'GetNetcf35PT':
  command   => "curl.exe -L -o ${netcf35PowerToysPath} ${netcf35PowerToysUrl}",
  creates => $netcf35PowerToysPath,
  provider  => powershell,
}
->
package { 'Power Toys for the Microsoft .NET Compact Framework 3.5':
  ensure => installed,
  source => $netcf35PowerToysPath,
}

package { 'Silverlight5SDK':
  ensure => installed,
  provider => chocolatey,
}

exec { 'GetNet451':
  command   => "curl.exe -L -o ${net451Path} ${net451Url}",
  creates => $net451Path,
  provider  => powershell,
}
->
package { 'Microsoft .NET Framework 4.5.1':
  ensure => installed,
  source => $net451Path,
  install_options => ['/q', '/norestart', '/repair'],
}

exec { 'GetNet40SDK':
  command => "curl.exe -L -o ${net40SDKIsoPath} ${net40SDKUrl}",
  creates => $net40SDKIsoPath,
  provider => powershell,
}
->
exec { 'Extract .NET 4.0 SDK Image':
  command => "C:\\Program Files\\7-Zip\\7z.exe x -tudf -o${net40SDKExtractLocation} ${net40SDKIsoPath}",
  creates => $net40SDKInstaller,
  provider => powershell
}
->
package { 'Microsoft .NET Framework 4.0 SDK':
  ensure => installed,
  source => $net40SDKInstaller,
  install_arguments => ['-q', '-params:ADDLOCAL=ALL']
}

exec { 'GetNet451SDK':
  command   => "curl.exe -L -o ${net451SDKPath} ${net451SDKUrl}",
  creates => $net451SDKPath,
  provider  => powershell,
}
->
package { 'Microsoft .NET Framework 4.5.1 SDK':
  ensure => installed,
  source => $net451SDKPath,
  install_arguments => ['-q']
}

package { 'mono3':
  ensure => '3.2.3',
  provider => chocolatey,
}
# -> no dependency because it seems that sometimes mono installation might seem to fail, though it works fine
exec { 'Add mono to path':
  command => "${appendPath} \"C:\\Program Files (x86)\\Mono-3.2.3\\bin\"",
  provider => powershell,
}

package { 'javaruntime':
  ensure => installed,
  provider => chocolatey,
}
->
exec {'Set JRE_HOME':
  command => '& SETX JRE_HOME "C:\Program Files (x86)\Java\jre7"',
  provider => powershell
}

Package['Microsoft .NET Compact Framework 2.0 SP2'] ->
  Package['Microsoft .NET Compact Framework 3.5'] ->
    Exec['Microsoft .NET Framework 3.5'] ->
      Package['Power Toys for the Microsoft .NET Compact Framework 3.5'] ->
        Package['Microsoft .NET Framework 4.0 SDK'] ->
          Package['Microsoft .NET Framework 4.5.1'] ->
            Package['Microsoft .NET Framework 4.5.1 SDK'] ->
              Package['Silverlight5SDK']