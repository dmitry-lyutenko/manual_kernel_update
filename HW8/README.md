###  1. создать свой RPM (можно взять свое приложение, либо собрать к примеру апач с определенными опциями)
Установка необходимых пакетов  
`yum install -y gcc curl redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils`  
Загрузим SRPM пакет NGINX для дальнейшей работы над ним:  
`wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.1-1.el7_4.ngx.src.rpm`  
`rpm -i nginx-1.14.1-1.el7_4.ngx.src.rpm`  
Скачиваем openssl  
`wget https://www.openssl.org/source/openssl-1.1.1f.tar.gz`  
`tar -xvf openssl-1.1.1f.tar.gz`  
`yum-builddep rpmbuild/SPECS/nginx.spec`  
В разделе %build в файле rpmbuild/SPECS/nginx.spec добавляем строку:    
`--with-openssl=/root/openssl-1.1.1f`    
Собираем RPM пакет    
`rpmbuild -bb rpmbuild/SPECS/nginx.spec`  
![picture](https://github.com/Andrey874/manual_kernel_update/blob/master/HW8/bezname.jpg)  
Устанавливаем nginx    
`yum localinstall -y rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm`  
Запускаем nginx  
`systemctl start nginx`  
`systemctl status nginx`  
![picture1](https://github.com/Andrey874/manual_kernel_update/blob/master/HW8/status.jpg)
### 2. создать свой репо и разместить там свой RPM  
Создадим  каталог repo:  
 `mkdir /usr/share/nginx/html/repo`  
 Копируем туда  собранный RPM и RPM для установки репозитория Percona-Server:  
 `cp rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm /usr/share/nginx/html/repo/`  
 `wget https://www.percona.com/redir/downloads/percona-release/redhat/0.1-6/percona-release-0.1-6.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm`
Инициализируем репозиторий командой:  
`createrepo /usr/share/nginx/html/repo/`  
В location / в файле /etc/nginx/conf.d/default.conf добавим директиву autoindex on.  
Проверяем синтаксис и перезапускаем NGINX:  
`nginx -t`  
`nginx -s reload`  
Создаем репозитарий.   
 `cat >> /etc/yum.repos.d/otus.repo << EOF`  
[otus]  
name=otus-linux  
baseurl=http://localhost/repo  
gpgcheck=0  
enabled=1  
EOF  
 Установим репозиторий percona-release  
 `yum install percona-release`  
 ![picture2](https://github.com/Andrey874/manual_kernel_update/blob/master/HW8/percona.jpg)



