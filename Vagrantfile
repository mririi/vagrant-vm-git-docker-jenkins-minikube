Vagrant.configure("2") do |config|
  
  config.vm.box = "bento/ubuntu-22.04"
  config.vm.hostname = "pfe"

 
  config.vm.network "private_network", ip: "192.168.49.2"

 
  config.vm.provider "virtualbox" do |vb|
 
    vb.cpus = "2" 
    vb.memory = "4096"
    vb.name = "pfe-vm"
   end
 
   config.vm.provision "shell", path: "setup.sh"

end
