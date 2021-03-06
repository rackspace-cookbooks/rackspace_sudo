#
# Cookbook Name:: rackspace_sudo_test
# Minitest:: cook-2119
#
# Copyright 2012-2013, Opscode, Inc.
# Copyright 2014, Rackspace, US Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require File.expand_path('../support/helpers', __FILE__)

describe 'rackspace_sudo_test::cook-2119' do
  include Helpers::RackspaceSudoTest

  it 'contains each command on a separate line' do
    file('/etc/sudoers.d/vagrant').must_include 'vagrant  ALL=(root) /bin/du'
    file('/etc/sudoers.d/vagrant').must_include 'vagrant  ALL=(root) /bin/ls'
  end
end
