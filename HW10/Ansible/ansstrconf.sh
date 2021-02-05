#!/bin/bash
yum install curl -y
yum install epel-release -y
yum install  ansible -y -q
ssh-keygen -q -t rsa -N "" -f "/home/vagrant/.ssh/id_rsa"
chown vagrant:vagrant /home/vagrant/.ssh/id_rsa
chown vagrant:vagrant /home/vagrant/.ssh/id_rsa.pub
chmod 0600 /home/vagrant/.ssh/id_rsa
chmod 0600 /home/vagrant/.ssh/id_rsa.pub
mkdir -p /root/.ssh/
cp -f /home/vagrant/.ssh/id_rsa /root/.ssh/
chown root:root /root/.ssh/id_rsa
chmod 0600 /root/.ssh/id_rsa
ssh-keyscan -t rsa 172.16.0.2 >> /home/vagrant/.ssh/known_hosts 2>/dev/null
chown vagrant:vagrant /home/vagrant/.ssh/known_hosts
chmod 0600 /home/vagrant/.ssh/known_hosts
ssh-keyscan -t rsa 172.16.0.2 >> /root/.ssh/known_hosts 2>/dev/null
sshpass -p "vagrant" ssh-copy-id -f -i /home/vagrant/.ssh/id_rsa.pub vagrant@172.16.0.2
ssh -i /root/.ssh/id_rsa vagrant@172.16.0.2 "sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config && sudo systemctl reload sshd"
mkdir /home/vagrant/ansible
mkdir /home/vagrant/ansible/playbook
mkdir /home/vagrant/ansible/templates
cp /vagrant/nginx.yml /home/vagrant/ansible/playbook
cp /vagrant/nginx.conf /home/vagrant/ansible/templates
cp /vagrant/nginx.conf.j2 /home/vagrant/ansible/templates
cp /vagrant/ansible.cfg /home/vagrant/ansible/
cp /vagrant/inventory /home/vagrant/ansible/
cd /home/vagrant/ansible/
sudo ansible-playbook /home/vagrant/ansible/playbook/nginx.yml 
