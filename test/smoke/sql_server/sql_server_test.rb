# # encoding: utf-8

# Inspec test for recipe sql_2016::sql_server

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe package('Microsoft SQL Server 2016 (64-bit)') do
  it { should be_installed }
end

describe port(1433) do
  it { should be_listening }
end

fw_script = <<-EOH
  netsh advfirewall firewall show rule 'MSSQLSERVER_Demo Static Port'
EOH

describe powershell(fw_script) do
  its('stdout') { should match(/Enabled:\s+Yes/) }
end
