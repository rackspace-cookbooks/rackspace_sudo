site :opscode

metadata

group :integration do
  cookbook "minitest-handler"
  cookbook "rackspace_apt", git: "rackspace-cookbooks/rackspace_apt", tag: "shuffle-updatenotifier"
  cookbook "rackspace_yum", git: "rackspace-cookbooks/rackspace_yum"
  cookbook "rackspace_sudo_test", :path => "./test/kitchen/cookbooks/rackspace_sudo_test"
end
