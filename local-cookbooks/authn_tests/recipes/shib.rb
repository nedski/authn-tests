#
# Cookbook Name:: acp_webserver
# Recipe:: mod_shib
#
# Copyright 2013, Neil Kohl, ACP
#
# Not for public distribution


### shibboleth base install/config for any acp web server
node[:server_name] = 'neilkmini.acponline.org'
node[:docroot]     = '/var/www/shib'
node[:application_name] = 'shib'
node[:apache][:listen_ports] = ['80', '8081']

package "libapache2-mod-shib2"
package "lynx-cur"

service "shibd" do
  service_name "Shibboleth 2 Daemon (Default)" if platform? 'windows'
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

template '/etc/apache2/sites-available/shib' 

remote_directory "/var/www/shib" do
  source "test-site"
  files_owner 'www-data'
end

%w{security-policy shibboleth2 acp-idp-metadata}.each do |cfg|
  cookbook_file "/etc/shibboleth/#{cfg}.xml" do
    action :create
    mode 0444
    notifies :restart, "service[shibd]", :delayed
  end
end

apache_module "info"
apache_module "shib2"

apache_site 'default' do
  enable false
end

apache_site 'shib' do
  enable
end