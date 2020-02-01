#default_box = 'image_to_use'
Vagrant.configure("2") do |config|
  config.ssh.insert_key = false
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 2048
    vb.cpus = 2
    vb.gui = false
  end
  config.vbguest.auto_update = false

  config.vm.define 'ansible' do |ansible|
	  # ansible.vm.box = "ubuntu/trusty64"
    # ansible.vm.box = "ubuntu/xenial64"
    ansible.vm.box = "ubuntu/bionic64"
  	ansible.vm.network :forwarded_port, guest: 22, host: 12202, id: 'ssh'
 	  ansible.vm.provision "file", source: "ansible_dev.cfg", destination: "ansible.cfg"
    ansible.vm.provision "file", source: "j2lint.py3", destination: "j2lint.py"
	  ansible.vm.provision 'shell', inline: <<-SHELL
      sleep 30
      sudo cp /vagrant/j2lint.py /usr/local/bin/j2lint.py
      chmod +x /usr/local/bin/j2lint.py
      chmod +x /vagrant/install.sh
	    sudo bash /vagrant/install.sh
    SHELL
  end


end
