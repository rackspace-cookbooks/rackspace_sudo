name              'rackspace_sudo'
maintainer        'Rackspace, US Inc.'
maintainer_email  'rackspace-cookbooks@rackspace.com'
license           'Apache 2.0'
description       'Installs sudo and configures /etc/sudoers'
version           '3.1.0'

recipe 'rackspace_sudo', 'Installs sudo and configures /etc/sudoers'

%w{redhat centos ubuntu debian}.each do |os|
  supports os
end
