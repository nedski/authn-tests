
# Use 2.4 PPA, info: https://launchpad.net/~derek-morton/+archive/apache-2.4
apt_repository "apache-2.4" do
  uri "http://ppa.launchpad.net/derek-morton/apache-2.4/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "A067E172"
end

package 'apache2'

# 
# script "install_program" do
#   not_if {File.exists?('/root/.ap2.4_installed')}
#   interpreter "bash"
#   user "root"
#   cwd "/tmp"
#   code <<-EOH
#     wget https://modmellon.googlecode.com/files/mod_auth_mellon-0.5.0.tar.gz
#     tar -zxf mod_auth_mellon-0.5.0.tar.gz
#     cd mod_auth_mellon-0.5.0
#     ./configure --prefix=/usr/local
#     make
#     make install
#   EOH
# end
# 
# file '/root/.ap2.4_installed' do
#   action :touch
# end
