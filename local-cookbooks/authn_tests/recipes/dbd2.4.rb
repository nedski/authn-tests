include_recipe "mysql::server"

# apache_module "authn_dbd"  
# apache_module "authz_dbd"
# apache_module "session_dbd"

%w{ authn_dbd authz_dbd session_dbd }.each do |what|
  execute("a2enmod #{what}") do
    returns 0
    command "/usr/sbin/a2enmod #{what}"
    retries 0
    action "run"
  end
end

db_name = 'acp_users'

cookbook_file "/tmp/init_acp_users.sql" do
  action :create
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

file '/root/.db_init_finished' do
  action :touch
end
