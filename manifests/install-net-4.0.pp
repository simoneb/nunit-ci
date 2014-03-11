$net40Url = "http://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe"
$net40Path = "c:\\vagrant\\downloads\\net40.exe"

exec { 'GetNet40':
  command   => "curl.exe -L -o ${net40Path} ${net40Url}",
  creates => $net40Path,
  provider  => powershell,
}
->
package { 'Microsoft .NET Framework 4.0':
  ensure => installed,
  source => $net40Path,
  install_options => ['/q', '/norestart', '/repair'],
}