$net451Url = "http://go.microsoft.com/fwlink/?LinkId=322116"
$net451Path = "c:\\vagrant\\downloads\\net451.exe"

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