name              'rackspace_sudo'
maintainer        'Rackspace, US Inc.'
maintainer_email  'rackspace-cookbooks@rackspace.com'
license           'Apache 2.0'
description       'Installs sudo and configures /etc/sudoers'
version           '3.0.0'

recipe 'rackspace_sudo', 'Installs sudo and configures /etc/sudoers'

%w{redhat centos ubuntu debian}.each do |os|
  supports os
end

attribute 'rackspace_sudo/config/authorization',
  :display_name => 'Authorization',
  :description => 'Hash of Authorization attributes',
  :type => 'hash'

attribute 'rackspace_sudo/config/authorization/sudo',
  :display_name => 'Authorization Sudoers',
  :description => 'Hash of Authorization/Sudo attributes',
  :type => 'hash'

attribute 'rackspace_sudo/config/authorization/sudo/users',
  :display_name => 'Sudo Users',
  :description => 'Users who are allowed sudo ALL',
  :type => 'array',
  :default => ''

attribute 'rackspace_sudo/config/authorization/sudo/groups',
  :display_name => 'Sudo Groups',
  :description => 'Groups who are allowed sudo ALL',
  :type => 'array',
  :default => ''

attribute 'rackspace_sudo/config/authorization/sudo/passwordless',
  :display_name => 'Passwordless Sudo',
  :description => '',
  :type => 'string',
  :default => 'false'

attribute 'rackspace_sudo/config/authorization/sudo/include_sudoers_d',
  :display_name => 'Include sudoers.d',
  :description => 'Whether to create the sudoers.d includedir',
  :type => 'string',
  :default => 'false'
