#!/bin/sh

# Run on VM to bootstrap the Foreman server
# Gary A. Stafford - 01/15/2015
# Modified - 08/19/2015
# Downgrade Puppet on box from 4.x to 3.x for Foreman 1.9 
# http://theforeman.org/manuals/1.9/index.html#3.1.2PuppetCompatibility

# Update system first
sudo apt -y update


# Installing puppet

source /etc/lsb-release
wget https://apt.puppetlabs.com/puppetlabs-release-$DISTRIB_CODENAME.deb
dpkg -i puppetlabs-release-$DISTRIB_CODENAME.deb
rm puppetlabs-release-$DISTRIB_CODENAME.deb


apt-get -y install ca-certificates
wget https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb
dpkg -i puppetlabs-release-pc1-xenial.deb 

echo "deb http://deb.theforeman.org/ xenial 1.13" | sudo tee --append /etc/apt/sources.list.d/foreman.list 2> /dev/null
echo "deb http://deb.theforeman.org/ plugins 1.13" | sudo tee --append /etc/apt/sources.list.d/foreman.list 2> /dev/null
sudo apt-get -y install ca-certificates
sudo /bin/bash -c 'wget -q https://deb.theforeman.org/pubkey.gpg -O- | apt-key add -'
sudo apt-get update && apt-get -y install foreman-installer

sudo foreman-installer

# Unless you have Foreman autosign certs, each agent will hang on this step until you manually
# sign each cert in the Foreman UI (Infrastrucutre -> Smart Proxies -> Certificates -> Sign)
# Aternative, run manually on each host, after provisioning is complete...
# sudo -i puppet agent --test --waitforcert=60