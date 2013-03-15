#
# Cookbook Name:: acp_webserver
# Recipe:: mod_shib
#
# Copyright 2013, Neil Kohl, ACP
#
# Not for public distribution

### shibboleth base install/config for any acp web server

package "libapache2-mod-shib2"
apache_module "shib2"