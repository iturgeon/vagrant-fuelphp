## Vagrant Setup for FuelPHP

This project sets up a Ubuntu Precise virtual machine to run your FuelPHP project in.  It mounts your fuelphp project directory so that you can use your favorite editors to work.

## What's in the Box?

Most of the following are including using Chef Opscode repositories.

* php5.4
* apache2
* mysql
* **fuel_dev** and **fuel_test** databases
* **fuellog** command that will tail the latest fuelphp log file
* vhost setup for your project
* composer is run for you

## Suggesting Setup & Layout

Add this Vagrant-FuelPHP to your project:

	$ git submodule add git@github.com:iturgeon/vagrant-fuelphp.git vagrant
	$ git submodule update --init --recursive
	$ cd vagrant
	$ vagrant up

Setup your directories something like this:

	project/
	project/fuel
	project/public/
	project/vagrant/

## Accessing your project

* **Browser**: [http://localhost:8080](http://localhost:8080)
* **Browser by IP**: [http://192.168.33.33](http://192.168.33.33)
* **Mysql**: mysql:host=192.168.33.33;dbname=fuel_dev (root user password is set in the Vagrantfile)
