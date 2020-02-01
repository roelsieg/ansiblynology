#!/bin/bash
#
# Remove reference to obsolete PuppetLabs repository
# Update to latest release
#
cat <<EOM
Ansible/NAPALM installation script
==================================
This script updates your system, installs additional APT and PIP
packages, and installs Ansible with NAPALM.
The script was adapted for and tested on Ubuntu 18.04. Do not use it
on earlier versions of Ubuntu. Within this repo this means using:
'ansible.vm.box = "ubuntu/bionic64"'in the Vagrantfile
NOTE: the script is set to abort on first error. If the installation
completed you're probably OK even though you might have seen errors
during the installation process.
==================================
EOM
set -e
#
# Comment the next line if you want to have verbose installation messages
QUIET=""
# QUIET="-qq"

YES="--assume-yes"
REPLACE="--ignore-installed --upgrade"
echo "Update installed software to latest release (might take a long time)"
sudo apt-get $QUIET update
#
# Install missing packages
#
echo "Install missing packages (also a pretty long operation)"
# sudo apt-get $YES $QUIET install python-setuptools ifupdown python3-pip >/dev/null
sudo apt-get $YES $QUIET install python-setuptools ifupdown python3-pip || true
echo "Install nice-to-have packages"
# sudo apt-get $YES $QUIET install git ack-grep jq tree sshpass colordiff >/dev/null
sudo apt-get $YES $QUIET install git ack-grep jq tree sshpass colordiff || true
#
# Install Ansible and NAPALM dependencies
#
echo "Install Python development and build modules"
# sudo apt-get $YES $QUIET install build-essential python3-dev libffi-dev >/dev/null
sudo apt-get $YES $QUIET install build-essential python3-dev libffi-dev || true
echo "Installing NAPALM dependencies"
# sudo apt-get $YES $QUIET install libxslt1-dev libssl-dev python3-lxml >/dev/null
sudo apt-get $YES $QUIET install libxslt1-dev libssl-dev python3-lxml || true
#
# Install Python components
#
echo "Install baseline Python components"
sudo pip3 install $REPLACE $QUIET pyyaml httplib2 pysnmp
sudo pip3 install $REPLACE $QUIET jinja2 six bracket-expansion netaddr
#
echo "Install Ansible Python dependencies"
echo ".. pynacl"
sudo pip3 install $REPLACE $QUIET pynacl
echo ".. paramiko netmiko"
sudo pip3 install $QUIET paramiko
sudo pip3 install $QUIET netmiko
#
echo "Install optional Python components"
sudo pip3 install $REPLACE $QUIET yamllint textfsm jmespath jxmlease jinja2
sudo pip3 install $QUIET ansible-lint
#
# Install latest Ansible version with pip
#
echo "Installing Ansible"
# 20191106 version pinned due to temp issue juniper ansible 2.9.0
sudo pip3 install $QUIET ansible==2.8.0
#
# Install NAPALM
#
echo "Installing NAPALM and Junos EZPY"
sudo pip3 install $QUIET napalm napalm-ansible
echo "Installing Junos roles"
sudo ansible-galaxy install juniper.junos
echo "Installation complete. Let's test Ansible and NAPALM version"
echo
ansible-playbook --version
# echo
# napalm-ansible
