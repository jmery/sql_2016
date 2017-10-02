# # encoding: utf-8

# Inspec test for recipe sql_2016::ssms

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe package('SQL Server Management Studio') do
  it { should be_installed }
end
