package "build-essential"
package "apache2-threaded-dev"
package "liblasso3-dev"
package "libcurl4-openssl-dev"
package "pkg-config"

script "install_program" do
  not_if {File.exists?('/root/.mellon_installed')}
  interpreter "bash"
  user "root"
  cwd "/tmp"
  code <<-EOH
    wget https://modmellon.googlecode.com/files/mod_auth_mellon-0.5.0.tar.gz
    tar -zxf mod_auth_mellon-0.5.0.tar.gz
    cd mod_auth_mellon-0.5.0
    ./configure
    make
    make install
  EOH
end

template "#{node[:apache][:dir]}/mods-available/auth_mellon.load" do
  source 'auth_mellon.load.erb'
  mode 0444
end
template "#{node[:apache][:dir]}/mods-available/auth_mellon.conf" do
  source 'auth_mellon.conf.erb'
  mode 0444
end

file '/root/.mellon_installed' do
  action :touch
end

apache_module "auth_mellon"  
