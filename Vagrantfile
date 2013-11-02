# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Base Box Used to create the fuelphp box
  # config.vm.box     = "precise64"
  # config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # This is the above box with all the dependencies built in
  config.vm.box     = "fuelphp"
  config.vm.box_url = "https://dl.dropboxusercontent.com/u/2215481/vagrant/fuelphp.box"
  
  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network :forwarded_port, guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # 
  config.vm.network :private_network, ip: "192.168.33.33"

  # Forward localhost:8080 to the guest vm
  config.vm.network :forwarded_port, guest: 80, host: 8080

  # use the chipset that seems to be faster for some reason
  # You can give it more ram/cpu hsere too
  config.vm.provider :virtualbox do |vb|
    vb.customize [ "modifyvm", :id, "--chipset", "ich9" ]
  end


  # Mount the parent directory at mnt/fuel using nfs if its there
  config.vm.synced_folder "../", "/mnt/fuelphp", :nfs => true


  config.vm.provision :chef_solo do |chef|

    # pass json_attribs to chef
    chef.json = {
      "mysql" => {
        "server_root_password"   => "root",
        'server_debian_password' => 'root',
        'server_repl_password'   => 'root',
        "allow_remote_root"      => true, # allows us to connect from the host
        "bind_address"           => "0.0.0.0", 
      },
      # which databases should we make?
      "db" => [
        "fuel_test",
        "fuel_dev"
      ],
      'apache' => {
        'listen_ports' => ['80', '8008']
      }
    }

    chef.cookbooks_path = "cookbooks"
    chef.add_recipe "fuelphp"

  end

end