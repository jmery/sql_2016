#
# Cookbook:: sql_2016
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

node.override['powershell']['installation_reboot_mode'] = 'no_reboot'

include_recipe 'powershell::powershell5'

reboot 'base_reboot' do
  action :request_reboot
  only_if { reboot_pending? }
end
