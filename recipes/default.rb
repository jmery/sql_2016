#
# Cookbook:: sql_2016
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'powershell::powershell5'

reboot 'base_reboot' do
  action :request_reboot
  only_if { reboot_pending? }
end
