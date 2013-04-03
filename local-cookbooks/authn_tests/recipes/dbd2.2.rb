include_recipe "mysql::server"
package "libaprutil1-dbd-mysql"

node[:server_name] = 'neilkmini.acponline.org'
node[:docroot]     = '/var/www/auth-mysql'
node[:application_name] = 'auth-mysql'
db_name = 'acp_users'

apache_module "dbd"  
apache_module "authn_dbd"  

db_name = 'acp_users'

template '/etc/apache2/sites-available/authn-dbd' do
  source 'auth-dbd2.2.erb'
end

remote_directory "/var/www/auth-mysql" do
  source "test-site"
  files_owner 'www-data'
end

cookbook_file "/tmp/init_acp_users_base64.sql" do
  action :create
end

cookbook_file "/tmp/init_base64.sql" do
  action :create
end


# create database
execute "create-acp-users-database" do
  command "/usr/bin/mysqladmin -u root  -p#{node[:mysql][:server_root_password]} create #{db_name} "
  not_if {::File.exists?('/root/.db_init_finished')}
end


# create base64 utilities
execute "init-base64" do
  command "\"#{node['mysql']['mysql_bin']}\" -u root #{node['mysql']['server_root_password'].empty? ? '' : '-p'  }#{node['mysql']['server_root_password']} #{db_name} < /tmp/init_base64.sql"
  not_if {::File.exists?('/root/.db_init_finished')}
end

# populate database
execute "init-acp-users-database" do
  command "\"#{node['mysql']['mysql_bin']}\" -u root #{node['mysql']['server_root_password'].empty? ? '' : '-p'  }#{node['mysql']['server_root_password']} #{db_name} < /tmp/init_acp_users_base64.sql"
  not_if {::File.exists?('/root/.db_init_finished')}
end

apache_module 'info' do
  enable
end

apache_site 'default' do
  enable false
end

apache_site 'authn-dbd' do
  enable
end

file '/root/.db_init_finished' do
  action :touch
end
