# PowerShell5 Attributes
default['powershell']['installation_reboot_mode'] = 'delayed_reboot'

# SQL Server Attributes
default['sql']['accept_eula'] = true
default['sql']['product_key'] = nil # Force nil for eval version
default['sql']['update_enabled'] = true
default['sql']['features'] = 'SQLENGINE,AS,RS,IS'
default['sql']['instance_name'] = 'MSSQLSERVER_Demo'
default['sql']['install_shared_dir'] = 'C:\Program Files\Microsoft SQL Server'
default['sql']['install_shared_wow_dir'] = 'C:\Program Files (x86)\Microsoft SQL Server'
default['sql']['rs_install_mode'] = 'DefaultNativeMode'
default['sql']['sql_telemetry_startup_type'] = 'Automatic'
default['sql']['as_telemetry_startup_type'] = 'Automatic'
default['sql']['is_telemetry_startup_type'] = 'Automatic'
default['sql']['telemetry_user'] = 'NT Service\SSISTELEMETRY130'
default['sql']['install_dir'] = default['sql']['install_shared_dir']
default['sql']['agent_svc_startup_type'] = 'Manual'
default['sql']['is_svc_startup_type'] = 'Automatic'
default['sql']['is_user'] = 'NT Service\MsDtsServer130'
default['sql']['as_svc_startup_type'] = 'Automatic'
default['sql']['as_collation'] = 'Latin1_General_CI_AS'
default['sql']['as_admin_accounts'] = 'BUILTIN\Administrators'
default['sql']['as_server_mode'] = 'MULTIDIMENSIONAL'
default['sql']['sql_svc_startup_type'] = 'Automatic'
default['sql']['sql_collation'] = 'SQL_Latin1_General_CP1_CI_AS'
default['sql']['sql_admin_accounts'] = 'BUILTIN\Administrators'
default['sql']['browser_svc_startup_type'] = 'Automatic'
default['sql']['reporting_svc_startup_type'] = 'Automatic'
default['sql']['install_timeout'] = 3000
default['sql']['remote_iso_url'] = 'https://s3.amazonaws.com/jmery/sql/SQLServer2016SP1-FullSlipstream-x64-ENU.iso'
default['sql']['remote_checksum'] = '2207dec43d8f1e9f95676dfce8c18a65d4551dfc01e149013a085ffddbfad0d4'
default['sql']['checksum'] = '9a1cdf87020c3f057e813b79941fb027e1c4201ac747ecc87903141d061ea092'
default['sql']['package_name'] = 'Microsoft SQL Server 2016 (64-bit)'
default['sql']['tcp_enabled'] = 1
default['sql']['port'] = 1433
default['sql']['tcp_dynamic_ports'] = ''

# SSMS Attributes
default['ssms']['installer_url'] = 'https://s3.amazonaws.com/jmery/sql/SSMS-Setup-ENU.exe'
default['ssms']['installer_url_checksum'] = '54692d0a38b44c6d0318c12c32ca69d3852c68116642914c8efdcba020c89dda'
default['ssms']['installer_filename'] = 'SSMS-Setup-ENU.exe'
default['ssms']['installer_filename_checksum'] = '54692d0a38b44c6d0318c12c32ca69d3852c68116642914c8efdcba020c89dda'
default['ssms']['package_name'] = 'SQL Server Management Studio'
default['ssms']['installer_timeout'] = 3000
