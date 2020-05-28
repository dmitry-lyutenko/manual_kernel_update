### Задание
#### Настройка мониторинга
#### Цель: В результате выполнения ДЗ студент настроит мониторинг.
#### Настроить дашборд с 4-мя графиками
#### 1) память
#### 2) процессор
#### 3) диск
#### 4) сеть
Используемая версия ОС - CentOS7. Устанавливаемая версия zabbix - 3.0.  
Основные команды используеммые при настройке  
`yum update`    
`rpm -Uvh https://repo.zabbix.com/zabbix/3.0/rhel/7/x86_64/zabbix-release-3.0-1.el7.noarch.rpm`  
`yum install zabbix-server-mysql zabbix-web-mysql zabbix-agent`  
`yum install mariadb-server -y`  
`systemctl start mariadb`  
`mysql_secure_installation` #смена пароля для доступа к БД  
`zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p zabbix`  
`/etc/zabbix/zabbix_server.conf` #настройки подключения к БД  
`systemctl enable zabbix-server`  
`systemctl start zabbix-server`  
`yum install zabbix-agent`  
`systemctl start httpd`  
`systemctl enable httpd`  
`systemctl enable mariadb`  
`systemctl start mariadb`    
`setsebool -P httpd_can_network_connect=1`  
`setsebool -P httpd_can_connect_zabbix=1`   
Дэшборд  
![picture5](https://github.com/Andrey874/manual_kernel_update/blob/master/HW18/2.jpg)
