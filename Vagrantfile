# Vagrant VM for k8s development

vmmemory = 2048
numcpu = 2

FileUtils.mkdir_p './.vagrant/tmp'

$script = <<-SCRIPT
echo Copying credentials to /home/vagrant...
sudo --user=vagrant mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown $(id -u vagrant):$(id -g vagrant) /home/vagrant/.kube/config
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox" do |v|
    v.memory = vmmemory
    v.cpus = numcpu
  end
  config.vm.provider "libvirt" do |v|
    v.memory = vmmemory
    v.cpus = numcpu
  end
  
  config.vm.box = "bento/ubuntu-18.04"
  # Specify your hostname if you like
  config.vm.box = "generic/ubuntu1804" 
  config.vm.hostname = "nebula-k8s" 

  # config.vm.network "private_network", type: "dhcp"
  config.vm.synced_folder ".vagrant/tmp/", "/vagrant", type: "nfs", mount_options: ["vers=3,tcp"]

  config.vm.provision "shell", path: "install/provision-master.sh"
  config.vm.provision "shell", inline: $script

  config.vm.define "master"
end
