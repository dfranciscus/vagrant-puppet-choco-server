class chocoserver {
  include chocolatey_server

    windows_firewall::exception { 'Choco server':
    ensure       => present,
    direction    => 'in',
    action       => 'Allow',
    enabled      => 'yes',
    protocol     => 'TCP',
    local_port   => '80',
    remote_port  => 'any',
    display_name => 'Chocolatey Simple Server',
    description  => 'Inbound rule for Chocolatey Server. [TCP 80]',
  }

  windowsfeature { 'Web-Basic-Auth':
    ensure => present,
    require => Class["chocolatey_server"]
  }

  exec { 'VirtualDir':
    command   => '$(Import-Module WebAdministration;New-Item IIS:\Sites\chocolatey.server\App_Data\Packages -type VirtualDirectory -physicalPath \\\\server\\packages$ -Force)',
    provider  => powershell,
    logoutput => true,
    require => Class["chocolatey_server"],
  }

  exec { 'ChocoAppPoolID':
    command => '$(Import-Module WebAdministration;Set-ItemProperty IIS:\AppPools\chocolatey.server -name processModel -value @{identitytype=2})',
    provider => powershell,
    logoutput => true,
    require => Class["chocolatey_server"],
  }

  exec { 'MaxAllowedContentLength':
    command => '$(Import-Module WebAdministration;Set-WebConfigurationProperty -filter /system.webserver/security/requestfiltering/requestLimits -name maxAllowedContentLength -value 50000000)',
    provider => powershell,
    logoutput => true,
    require => Class["chocolatey_server"],
  }

  #class {'itg_ssl_wildcard':
  #    require => Class["chocolatey_server"],
  #  }
  
}
