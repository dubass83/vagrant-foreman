### Installing Foreman and Puppet Agent on Multiple VMs Using Vagrant and VirtualBox
Automatically install and configure Foreman, the open source infrastructure life-cycle management tool, and multiple Puppet Agent VMs using Vagrant and VirtualBox. 


#### Vagrant Plug-ins
This project requires the Vagrant vagrant-hostmanager plugin to be installed. The Vagrantfile uses the vagrant-hostmanager plugin to automatically ensure all DNS entries are consistent between guests as well as the host, in the `/etc/hosts` file. An example of the modified `/etc/hosts` file is shown below.

```text
## vagrant-hostmanager-start id: 
192.168.35.5  theforeman.example.com
192.168.35.10 agent01.example.com
192.168.35.20 agent02.example.com
## vagrant-hostmanager-end
```

You can manually run `vagrant hostmanager` to update `/etc/hosts` at anytime.  

This project also requires the Vagrant vagrant-vbguest plugin is also used to keep the vbguest tools updated.
```sh
vagrant plugin install vagrant-hostmanager
vagrant plugin install vagrant-vbguest
```

#### Yaml Configuration File
The `Vagrantfile` retrieves multiple VM configurations from a separate `nodes.yaml` YAML file. You can add additional VMs to the YAML file, following the existing pattern. 


#### Instructions
Provision the Foreman VM first, before the agents. It will takes several minutes to fully provision the VM.
```sh
vagrant up theforeman.example.com
```

Important, when the provisioning is complete, note the output from Vagrant. The output provides the `admin` login password and URL for the Foreman console. Example output below.
```text
==> theforeman.example.com:   Success!
==> theforeman.example.com:   * Foreman is running at https://theforeman.example.com
==> theforeman.example.com:       Initial credentials are admin / 7x2fpZBWgVEHvzTw
==> theforeman.example.com:   * Foreman Proxy is running at https://theforeman.example.com:8443
==> theforeman.example.com:   * Puppetmaster is running at port 8140
==> theforeman.example.com:   The full log is at /var/log/foreman-installer/foreman-installer.log
```
Log into Foreman's browser-based console using the information provided in the output from Vagrant (example above). Change the `admin` account password, and/or set-up your own `admin` account(s).

Next, build two puppet agent VMs. Again, it will takes several minutes to fully provision the two VMs.
```sh
vagrant up agent01.example.com agent02.example.com
```


