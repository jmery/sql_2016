#
# Cookbook:: sql_2016
# Recipe:: sql_server
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Set a few variables so we don't have to type as much
cfg_file = "#{Chef::Config[:file_cache_path]}\\ConfigFile.ini"
iso_file = "#{Chef::Config[:file_cache_path]}\\sql.iso"
# This could be cleaner but we're in a hurry
db_installed = File.exist?("#{node['sql']['install_dir']}\\MSSQL13.#{node['sql']['instance_name']}\\MSSQL\\DATA\\master.mdf")

# Copy the install response file from our template
template cfg_file do
  source 'ConfigFile.ini.erb'
  action :create
  not_if { db_installed }
end

# Copy the ISO file so we can install from a local source
remote_file iso_file do
  source node['sql']['remote_iso_url'].to_s
  checksum node['sql']['remote_checksum'].to_s
  action :create
  not_if { db_installed }
  notifies :run, 'powershell_script[mount_sql_iso_image]', :immediately
end

# Mount the ISO file as a drive so we can install from there
powershell_script 'mount_sql_iso_image' do
  code <<-EOH
  Mount-DiskImage #{iso_file}
  EOH
  not_if '($SQL_Server_ISO_Drive_Letter = (gwmi -Class Win32_LogicalDisk | Where-Object {$_.VolumeName -eq "SQL2016_x64_ENU"}).VolumeName -eq "SQL2016_x64_ENU")'
  only_if { File.exist?(iso_file) }
  notifies :run, 'ruby_block[get_iso_mount_drive_letter]', :immediately
end

# Because we don't use a hard-coded drive letter, we have to figure out where we
# mounted the ISO file.  This has to be wrapped in a `ruby_block` to trick Chef
# to wait until converge for this to run.  Otherwise it runs during the compile
# phase and we get a `NilClass` error.
#
# This could be removed by coding a drive letter into the `powershell_script`
# resource above that mounts the image.
ruby_block 'get_iso_mount_drive_letter' do
  block do
    node.run_state['drive_letter'] = powershell_out!("return (Get-DiskImage #{iso_file} | Get-Volume).DriveLetter").stdout.chop
  end
  action :nothing
end

# Install SQL Server using the mounted installer and our response file
package node['sql']['package_name'] do
  source lazy { "#{node.run_state['drive_letter']}:\\setup.exe" }
  checksum node['sql']['checksum'].to_s
  options "/ConfigurationFile=#{cfg_file}"
  installer_type :custom
  timeout node['sql']['install_timeout']
  not_if { db_installed }
  notifies :run, 'execute[open-static-port]', :immediately
  notifies :run, 'powershell_script[dismount_sql_iso_image]', :immediately
end

# Don't want to leave the ISO mounted
powershell_script 'dismount_sql_iso_image' do
  code <<-EOH
    Dismount-DiskImage -ImagePath #{iso_file}
  EOH
  action :nothing
  notifies :delete, "file[#{iso_file}]", :immediately
end

# Clean up our response file
file cfg_file do
  action :delete
end

# Clean up our ISO file because it's kind of big
file iso_file do
  action :nothing
end

# Set SQL Server port for our instance
service_name = 'MSSQL$' + node['sql']['instance_name']
agent_service_name = 'SQLAgent$' + node['sql']['instance_name']

reg_prefix = "HKLM\\SOFTWARE\\Microsoft\\Microsoft SQL Server\\MSSQL13.#{node['sql']['instance_name']}\\MSSQLServer"

# Set SQL Server to run on our custom port attribute node['sql']['port']. Defaults to 1433.
registry_key "#{reg_prefix}\\SuperSocketNetLib\\Tcp\\IPAll" do
  values [{ name: 'Enabled', type: :dword, data: node['sql']['tcp_enabled'] ? 1 : 0 },
          { name: 'TcpPort', type: :string, data: node['sql']['port'].to_s },
          { name: 'TcpDynamicPorts', type: :string, data: node['sql']['tcp_dynamic_ports'].to_s }]
  recursive true
  notifies :restart, "service[#{service_name}]", :immediately
end

# Open the firewall to our custom port attribute node['sql']['port']
firewall_rule_name = "#{node['sql']['instance_name']} Static Port"

execute 'open-static-port' do
  command "netsh advfirewall firewall add rule name=\"#{firewall_rule_name}\" dir=in action=allow protocol=TCP localport=#{node['sql']['port']}"
  returns [0, 1, 42] # *sigh* cmd.exe return codes are wonky
  not_if "netsh advfirewall firewall show rule \"#{firewall_rule_name}\""
end

# No-op block to restart our services if we change certain things
# Look for `notifies` statements anywhere above
service service_name do
  action [:enable, :start]
  restart_command %(powershell.exe -C "restart-service '#{service_name}' -force")
end

# No-op block to restart our services if we change certain things
# Look for `notifies` statements anywhere above
service agent_service_name do
  action [:enable, :start]
  restart_command %(powershell.exe -C "restart-service '#{agent_service_name}' -force")
end

# Reboot things if the installer requires it
reboot 'sql_reboot' do
  action :request_reboot
  only_if { reboot_pending? }
end
