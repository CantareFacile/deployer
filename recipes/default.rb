#
# Author:: Seth Vargo <sethvargo@gmail.com>
# Cookbook Name:: deployer
# Recipe:: default
#
# Copyright 2012, Seth Vargo
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

# GRP deploy
group node['deployer']['group'] do
  gid       5000
end

# USER deploy
user node['deployer']['user'] do
  comment   'The deployment user'
  uid       5000
  gid       5000
  shell     '/bin/bash'
  home      node['deployer']['home']
  supports  :manage_home => true
end

# SUDO deploy
sudo node['deployer']['user'] do
  user      node['deployer']['user']
  group     node['deployer']['group']
  commands  ['ALL']
  host      'ALL'
  nopasswd  true
end

# DIR /home/deploy/.ssh
directory "#{node['deployer']['home']}/.ssh" do
  owner     node['deployer']['user']
  group     node['deployer']['group']
  mode      '0700'
  recursive true
end

authorized_keys = File.read("/root/.ssh/authorized_keys")

file "#{node['deployer']['home']}/.ssh/authorized_keys" do
  owner     node['deployer']['user']
  group     node['deployer']['group']
  mode      '0644'
  action :create_if_missing
  content authorized_keys
end