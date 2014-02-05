require 'spec_helper'

describe 'rackspace_sudo::default' do
  context 'usual business' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04').converge 'rackspace_sudo::default'
    end

    it 'installs the sudo package' do
      expect(chef_run).to install_package('sudo')
    end

    it 'creates the /etc/sudoers file' do
      expect(chef_run).to render_file('/etc/sudoers').with_content('Defaults      !lecture,tty_tickets,!fqdn')
    end
  end

  context 'with custom prefix' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04') do |node|
        node.set['rackspace_sudo']['config']['authorization']['sudo']['prefix'] = '/secret/etc'
      end.converge 'rackspace_sudo::default'
    end

    it 'creates the sudoers file in the custom location' do
      expect(chef_run).to render_file('/secret/etc/sudoers').with_content('Defaults      !lecture,tty_tickets,!fqdn')
    end
  end

  context 'sudoers.d' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04') do |node|
        node.set['rackspace_sudo']['config']['authorization']['rackspace_sudo']['include_sudoers_d'] = 'true'
      end.converge 'rackspace_sudo::default'
    end

    it 'creates the sudoers.d directory' do
      expect(chef_run).to create_directory('/etc/sudoers.d').with(
        user: 'root',
        group:  'root',
      )
    end

    it 'drops the README file' do
      expect(chef_run).to create_file('/etc/sudoers.d/README').with_content('As of Debian version 1.7.2p1-1, the default /etc/sudoers file created on')
    end
  end
end
