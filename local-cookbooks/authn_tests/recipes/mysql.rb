include_recipe "mysql::server"
package "libapache2-mod-auth-mysql"
apache_module "auth_mysql"  

node[:server_name] = 'neilkmini.acponline.org'
node[:docroot]     = '/var/www/auth-mysql'
node[:application_name] = 'auth-mysql'
db_name = 'acp_users'

cookbook_file "/tmp/init_acp_users.sql" do
  action :create
end

template '/etc/apache2/sites-available/auth-mysql' do
  source 'default.erb'
end

remote_directory "/var/www/auth-mysql" do
  source "test-site"
  files_owner 'www-data'
end

# create database
execute "create-acp-users-database" do
  command "/usr/bin/mysqladmin -u root  -p#{node[:mysql][:server_root_password]} create #{db_name} "
  not_if {::File.exists?('/root/.db_init_finished')}
end

# populate database
execute "init-acp-users-database" do
  command "\"#{node['mysql']['mysql_bin']}\" -u root #{node['mysql']['server_root_password'].empty? ? '' : '-p'  }#{node['mysql']['server_root_password']} #{db_name} < /tmp/init_acp_users.sql"
  not_if {::File.exists?('/root/.db_init_finished')}
end
apache_module 'info' do
  enable
end

apache_site 'default' do
  enable false
end

apache_site 'auth-mysql' do
  enable
end
  
file '/root/.db_init_finished' do
  action :touch
end


