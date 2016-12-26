# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'vagrant/ui'
require 'yaml'
require 'fileutils'

UI = Vagrant::UI::Colored.new

MACHINE_CONFIG_PATH = "nodes.yaml"

# Builds single Foreman server and 
# multiple Puppet Agent Nodes using YAML config file
# Sych M.  - 23/12/2016
# Modified - 24/12/2016


UI.info 'Reading Machine Config...'
nodes_config = YAML.load_file(Pathname.new(MACHINE_CONFIG_PATH).realpath)


UI.info 'Configuring VirtualBox Host-Only Network...'


VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # configure vagrant-hostmanager plugin
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.ignore_private_ip = false

  # Avoid random ssh key for demo purposes
  config.ssh.insert_key = false
  
  # Vagrant Plugin Configuration: vagrant-vbguest
  if Vagrant.has_plugin?('vagrant-vbguest')
    # enable auto update guest additions
    config.vbguest.auto_update = true
  end


  nodes_config.each do |node_name, node_values|

    UI.info "--------------------------------------"
    UI.info node_name
    UI.info node_values['box']
    UI.info node_values['ip']
    UI.info "--------------------------------------"
    config.vm.define node_name do |machine|
      machine.vbguest.auto_update = true
      machine.vbguest.iso_path = "http://download.virtualbox.org/virtualbox/%{version}/VBoxGuestAdditions_%{version}.iso"
    
      machine.vm.box = node_values['box']

## configures all forwarding ports in JSON array
#      ports = node_values['ports']
#      ports.each do |port|
#        machine.vm.network :forwarded_port,
#          host:  port['host'],
#          guest: port['guest'],
#          id:    port['id']
#      end

      machine.vm.hostname = node_name


      machine.vm.provider :virtualbox do |vb, override|
        vb.customize ["modifyvm", :id, "--memory", node_values['memory']]
        vb.customize ["modifyvm", :id, "--name", node_name]
        vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
        
        override.vm.network :private_network, ip: node_values['ip']
        # disable usb
        vb.customize ["modifyvm", :id, "--usb", "off"]
        vb.customize ["modifyvm", :id, "--usbehci", "off"]

        # guest should sync time if more than 10s off host
        vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000 ]
      end
      
      machine.vm.provision :shell, :path => node_values['bootstrap']

    end
  end
end
