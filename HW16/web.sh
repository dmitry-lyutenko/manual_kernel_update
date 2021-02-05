#!/bin/bash
yum install epel-release -y
yum install nginx -y
cp /vagrant/web/logs_forwarder.conf /etc/rsyslog.d/
cp /vagrant/web/nginx.conf /etc/nginx/
cp /vagrant/web/rsyslog.conf /etc/
auditctl -w /etc/nginx -p wa
sudo systemctl restart rsyslog
sudo systemctl enable nginx
sudo systemctl start nginx


