# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "puppet" do |puppet|
    puppet.vm.box = "bento/centos-7.2"
    puppet.vm.network "private_network", ip: "192.168.10.21"
    puppet.vm.hostname = "puppet"
    puppet.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "4096"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
      end
    puppet.vm.provision "shell", inline: <<-SHELL
      sudo echo "192.168.10.22 puppetagent-1" | sudo tee -a /etc/hosts
      sudo echo "192.168.10.23 puppetagent-2" | sudo tee -a /etc/hosts
      sudo systemctl enable firewalld
      sudo systemctl start firewalld
      sudo firewall-cmd --permanent --zone=public --add-port=8140/tcp 
      sudo yum -y install ntp
      sudo timedatectl set-timezone America/New_York
      sudo systemctl start ntpd
      sudo firewall-cmd --add-service=ntp --permanent
      sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
      sudo yum -y install puppetserver
      sudo touch /etc/puppetlabs/puppet/autosign.conf
      sudo echo "*" | sudo tee -a /etc/puppetlabs/puppet/autosign.conf
      sudo firewall-cmd --reload
      sudo systemctl enable puppetserver
      sudo systemctl start puppetserver           
    SHELL
  end

  config.vm.define "puppetagent-1" do |puppetagent1|
    puppetagent1.vm.box = "bento/centos-7.2"
    puppetagent1.vm.network "private_network", ip: "192.168.10.22"
    puppetagent1.vm.hostname = "puppetagent-1"
    puppetagent1.vm.provision "shell", inline: <<-SHELL
       sudo echo "192.168.10.21 puppet" | sudo tee -a /etc/hosts
       sudo timedatectl set-timezone America/New_York
       sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
       sudo yum -y install puppet-agent
       sudo /opt/puppetlabs/bin/puppet agent --test
    SHELL
    end

    config.vm.define "puppetagent-2" do |puppetagent2|
      puppetagent2.vm.box = "bento/centos-7.2"
      puppetagent2.vm.network "private_network", ip: "192.168.10.23"
      puppetagent2.vm.hostname = "puppetagent-2"
      puppetagent2.vm.provision "shell", inline: <<-SHELL
       sudo echo "192.168.10.21 puppet" | sudo tee -a /etc/hosts
       sudo timedatectl set-timezone America/New_York
       sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
       sudo yum -y install puppet-agent
       sudo /opt/puppetlabs/bin/puppet agent --test
    SHELL
  end

  config.vm.define "puppetagentwin" do |puppetagentwin|
     puppetagentwin.vm.box = "eratiner/w2016x64vmX"
      puppetagentwin.vm.network "private_network", ip: "192.168.10.24"
      puppetagentwin.vm.hostname = "puppetagentwin"
      puppetagentwin.vm.provision "shell", inline: <<-SHELL
       Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
       choco install puppet-agent -y -installArgs '"PUPPET_AGENT_STARTUP_MODE=Disabled"'
       #Add host file entry for puppet master

       refreshenv
    SHELL
  end
end


