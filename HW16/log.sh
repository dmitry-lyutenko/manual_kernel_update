#!/bin/bash
cp /vagrant/log/logs_from_web.conf /etc/rsyslog.d/
cp /vagrant/log/rsyslog.conf /etc/
sudo systemctl restart rsyslog

