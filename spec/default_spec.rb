require 'spec_helper'

describe 'rackspace_sudo::default' do
  before do
    stub_command('which sudo').and_return(nil)
  end

  context 'usual business' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04').converge('rackspace_sudo::default')
    end

    it 'installs the sudo package' do
      expect(chef_run).to install_package('sudo')
    end

    it 'creates the /etc/sudoers file' do
      expect(chef_run).to render_file('/etc/sudoers').with_content('Defaults      !lecture,tty_tickets,!fqdn')
    end
    it 'creates a template' do
      expect(chef_run).to create_template('/etc/sudoers')
    end
  end

  context 'with custom prefix' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04') do |node|
        node.set['rackspace_sudo']['config']['authorization']['sudo']['prefix'] = '/secret/etc'
      end.converge('rackspace_sudo::default')
    end

    it 'creates the sudoers file in the custom location' do
      expect(chef_run).to create_template('/secret/etc/sudoers')
    end
  end

  context "node['rackspace_sudo']['config']['authorization']['sudo']['users']" do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04') do |node|
        node.set['rackspace_sudo']['config']['authorization']['sudo']['users'] = %w(bacon)
      end.converge('rackspace_sudo::default')
    end

    it 'adds users of the bacon group to the sudoers file' do
      expect(chef_run).to render_file('/etc/sudoers').with_content('bacon')
    end
  end

  context "node['rackspace_sudo']['config']['authorization']['sudo']['groups']" do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04') do |node|
        node.set['rackspace_sudo']['config']['authorization']['sudo']['groups'] = %w(bacon)
      end.converge('rackspace_sudo::default')
    end

    it 'adds users of the bacon group to the sudoers file' do
      expect(chef_run).to render_file('/etc/sudoers').with_content('%bacon ALL=(ALL)')
    end
  end

  context "node['rackspace_sudo']['config']['authorization']['sudo']['passwordless']" do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04') do |node|
        node.set['rackspace_sudo']['config']['authorization']['sudo']['users'] = %w(bacon)
        node.set['rackspace_sudo']['config']['authorization']['sudo']['groups'] = %w(bacon)
        node.set['rackspace_sudo']['config']['authorization']['sudo']['passwordless'] = true
      end.converge('rackspace_sudo::default')
    end

    it 'gives users and groups passwordless sudo' do
      expect(chef_run).to render_file('/etc/sudoers').with_content('bacon ALL=(ALL) NOPASSWD:ALL')
      expect(chef_run).to render_file('/etc/sudoers').with_content('%bacon ALL=(ALL) NOPASSWD:ALL')
    end
  end

  context "node['rackspace_sudo']['config']['authorization']['sudo']['agent_forwarding']" do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04') do |node|
        node.set['rackspace_sudo']['config']['authorization']['sudo']['agent_forwarding'] = true
      end.converge('rackspace_sudo::default')
    end

    it 'includes ssh forwarding in the sudoers file' do
      expect(chef_run).to render_file('/etc/sudoers').with_content('Defaults      env_keep+=SSH_AUTH_SOCK')
    end
  end

  context "node['rackspace_sudo']['config']['authorization']['sudo']['sudoers_defaults']" do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04') do |node|
        node.set['rackspace_sudo']['config']['authorization']['sudo']['sudoers_defaults'] = %w(ham bacon)
      end.converge('rackspace_sudo::default')
    end

    it 'includes each default' do
      expect(chef_run).to render_file('/etc/sudoers').with_content('Defaults      ham')
      expect(chef_run).to render_file('/etc/sudoers').with_content('Defaults      bacon')
    end
  end

  context "node['rackspace_sudo']['config']['authorization']['sudo']['prefix']" do
    context 'on Ubuntu' do
      let(:chef_run) { ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04').converge('rackspace_sudo::default') }

      it 'uses /etc' do
        expect(chef_run).to render_file('/etc/sudoers').with_content('Defaults      !lecture,tty_tickets,!fqdn')
      end
    end
  end

  context 'sudoers.d' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04') do |node|
        node.set['rackspace_sudo']['config']['authorization']['sudo']['include_sudoers_d'] = true
      end.converge('rackspace_sudo::default')
    end

    it 'creates the sudoers.d directory' do
      expect(chef_run).to create_directory('/etc/sudoers.d').with(
        owner: 'root',
        mode:  '0755'
      )
    end
  end
end
