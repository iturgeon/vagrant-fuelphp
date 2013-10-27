# Run apt-get update
execute "update" do
    command "apt-get update"
    user "root"
    not_if "which php"
end

# need this to add php5  below
package "python-software-properties" do
    action :install
    options "--force-yes"
    not_if "which php"
end

# old stable should keep us from installing a php too new for the apache cookbook
execute "add-apt-repository ppa:ondrej/php5" do
    command "add-apt-repository ppa:ondrej/php5-oldstable"
    user "root"
    not_if "which php"
end

execute "update" do
    command "apt-get update"
    user "root"
    not_if "which php"
end

# install LAMP setup
include_recipe "apache2"
include_recipe "mysql"
include_recipe "mysql::server"
include_recipe "php"
include_recipe "php::module_mysql"
include_recipe "php::module_gd"
include_recipe "apache2::mod_php5"
include_recipe "apache2::mod_rewrite"

# setup the vhost
web_app "fuelphp" do
	template "web_app.conf.erb"
	docroot "/mnt/fuelphp"
	server_name server_fqdn
	server_aliases "fuelphp"
end

# create the databases
node[:db].each do |name|
    execute "create database #{name}" do
        command "mysql -uroot -p#{node[:mysql][:server_root_password]} -e 'create database if not exists #{name}'"
        user "vagrant"
    end
end

# add a quick symlink
link "/home/vagrant/fuelphp" do
    to "/mnt/fuelphp"
end

# copy our fuellog convinience script for monitoring fuelphp logs
cookbook_file '/usr/local/bin/fuellog' do
    source "fuellog"
    mode "0755"
    owner "vagrant"
    group "root"
end

# run composer
execute "php composer.phar install" do
    command "php composer.phar install"
    cwd "/mnt/fuelphp"
    creates "/mnt/fuelphp/composer.lock"
end

# =================== OPTIONAL STUFF ===================== #

# include_recipe "php::module_curl"

# install additional libraries like curl
# package "curl" do
#     action :install
# end

# package "php5-curl" do
#     action :install
# end

# run your fuelphp install task
# execute "fuel php install" do
#     command "php oil r install"
#     cwd "/mnt/fuelphp"
#     creates "/mnt/fuelphp/fuel/app/config/development/migrations.php"
# end

# run your migrations
# execute "fuel php migrate" do
#     command "php oil r migrate"
#     cwd "/mnt/fuelphp"
#     creates "/mnt/fuelphp/fuel/app/config/development/migrations.php"
# end