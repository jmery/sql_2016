#
# Cookbook:: sql_2016
# Recipe:: ssms
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Set a few variables so we don't have to type as much
ssms_installer = "#{Chef::Config[:file_cache_path]}\\#{node['ssms']['installer_filename']}"

# Get installer file from a remote location
# Skip this if SSMS is already installed by checking the Ohai attributes
remote_file ssms_installer do
  source node['ssms']['installer_url'].to_s
  checksum node['ssms']['installer_url_checksum'].to_s
  action :create
  not_if { node['packages'].attribute?(node['ssms']['package_name']) }
end

# Install SSMS
package node['ssms']['package_name'] do
  source ssms_installer
  checksum node['ssms']['installer_filename_checksum'].to_s
  options '/install /quiet /norestart'
  installer_type :custom
  timeout node['ssms']['installer_timeout']
#  only_if { File.exist?(ssms_installer) }
end

# Clean up installer file because it's kind of big
file ssms_installer do
  action :delete
end

# Reboot if required
reboot 'ssms_install_request_reboot' do
  reason 'SSMS installation requires a reboot'
  action :request_reboot
  only_if { reboot_pending? }
end
