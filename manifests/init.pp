node /access/ {
  # Setup pre and post run stages
  # Typically these are only needed in special cases but are good to have
  stage { ['pre', 'post']: }
  Stage['pre'] -> Stage['main'] -> Stage['post']

  # Install text editors
  package { 'vim-enhanced': ensure => installed }
  package { 'emacs':        ensure => installed }
  
  #Install nmap etc
  package { 'nmap':        ensure => installed }
  package { 'telnet':        ensure => installed }
  package { 'firefox':    ensure => installed }

  # Declare the Harvard class for a Harvard look and feel
  class { 'harvard': }
  
  $packages = [
    'atk', 'cairo', 'dbus', 'dbus-libs', 'fontconfig', 'freetype', 'glib2',
    'gtk2', 'libICE', 'libSM', 'libX11', 'libXext', 'libXft', 'libXi',
    'libXrender', 'libXt', 'libXtst', 'libpng', 'libxml2', 'mesa-libGL',
    'mesa-libGLU', 'pango', 'qt', 'qt3', 'redhat-lsb-graphics',
    'redhat-lsb-printing',
    'alsa-plugins-pulseaudio', 'at-spi', 'control-center', 'gdm',
    'gdm-user-switch-applet', 'gnome-panel', 'gnome-power-manager',
    'gnome-screensaver', 'gnome-session', 'gnome-terminal', 'gvfs-archive',
    'gvfs-fuse', 'gvfs-smb', 'metacity', 'nautilus', 'notification-daemon',
    'polkit-gnome', 'xdg-user-dirs-gtk', 'yelp', 'control-center-extra',
    'eog', 'gdm-plugin-fingerprint', 'gnome-applets', 'gnome-media',
    'gnome-packagekit', 'gnome-vfs2-smb', 'gok', 'openssh-askpass', 'orca',
    'pulseaudio-module-gconf', 'pulseaudio-module-x11', 'vino',
  ]
  package { $packages:
    ensure => installed,
  }

  $fonts = [
    'abyssinica-fonts', 'cjkuni-uming-fonts', 'dejavu-sans-fonts',
    'dejavu-sans-mono-fonts', 'dejavu-serif-fonts', 'jomolhari-fonts',
    'khmeros-base-fonts', 'kurdit-unikurd-web-fonts',
    'liberation-mono-fonts', 'liberation-sans-fonts',
    'liberation-serif-fonts', 'lklug-fonts', 'lohit-assamese-fonts',
    'lohit-bengali-fonts', 'lohit-devanagari-fonts', 'lohit-gujarati-fonts',
    'lohit-kannada-fonts', 'lohit-oriya-fonts', 'lohit-punjabi-fonts',
    'lohit-tamil-fonts', 'lohit-telugu-fonts', 'madan-fonts',
    'paktype-naqsh-fonts', 'paktype-tehreer-fonts', 'sil-padauk-fonts',
    'smc-meera-fonts', 'stix-fonts', 'thai-scalable-waree-fonts',
    'tibetan-machine-uni-fonts', 'un-core-dotum-fonts', 'vlgothic-fonts',
    'wqy-zenhei-fonts',
  ]
  package { $fonts:
    ensure => installed,
  }
  
  package { 'freenx':
    ensure => installed,
  }
  service { 'freenx-server':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['freenx'],
  }
  exec { 'nx_setup':
    # --setup-nomachine-key is important as we use the keys distrubuted with
    # the nxclient apps.
    #
    # Keep in mind that this only runs when the package resource changes
    # (is installed, Puppet forces a version upgrade, etc.).
    command     => '/usr/bin/nxsetup --auto --install --setup-nomachine-key',
    refreshonly => true,
    subscribe   => Package['freenx'],
  }
  
  service {'iptables':
    ensure => stopped,
  }
  
}

node default {
  # Setup pre and post run stages
  # Typically these are only needed in special cases but are good to have
  stage { ['pre', 'post']: }
  Stage['pre'] -> Stage['main'] -> Stage['post']

  # Install text editors
  package { 'vim-enhanced': ensure => installed }
  package { 'emacs':        ensure => installed }
  
  #Install nmap etc
  package { 'nmap':        ensure => installed }
  package { 'telnet':        ensure => installed }
  
  # Declare the Harvard class for a Harvard look and feel
  class { 'harvard': }
  class { 'havana::role::controller': }


#----- forklift swift module test all.pp -----
  #
  #
  # This example file is almost the
  # can be used to build out a sample swift all in one environment
  #
  $swift_local_net_ip='127.0.0.1'

  $swift_shared_secret='eb374842f6504c897dde'

  Exec { logoutput => true }

  package { 'curl': ensure => present }


#  class { 'memcached':
#    listen_ip => $swift_local_net_ip,
#  }

  class { 'swift':
    # not sure how I want to deal with this shared secret
    swift_hash_suffix => $swift_shared_secret,
    package_ensure    => latest,
  }

  # === Configure Storage

  class { 'swift::storage':
    storage_local_net_ip => $swift_local_net_ip
  }

  # create xfs partitions on a loopback device and mounts them
  swift::storage::loopback { '2':
    require => Class['swift'],
  }

  # sets up storage nodes which is composed of a single
  # device that contains an endpoint for an object, account, and container

  swift::storage::node { '2':
    mnt_base_dir         => '/srv/node',
    weight               => 1,
    manage_ring          => true,
    zone                 => '2',
    storage_local_net_ip => $swift_local_net_ip,
    require              => Swift::Storage::Loopback[2] ,
  }

  class { 'swift::ringbuilder':
    part_power     => '18',
    replicas       => '1',
    min_part_hours => 1,
    require        => Class['swift'],
  }


  # TODO should I enable swath in the default config?
  class { 'swift::proxy':
    proxy_local_net_ip => $swift_local_net_ip,
    pipeline           => ['healthcheck', 'cache', 'tempauth', 'proxy-server'],
    account_autocreate => true,
    require            => Class['swift::ringbuilder'],
  }
  class { ['swift::proxy::healthcheck', 'swift::proxy::cache', 'swift::proxy::tempauth']: }


}
# vim: set ft=puppet ts=2 sw=2 ei:
