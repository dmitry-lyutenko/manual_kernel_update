### Задание 1.
#### Создать сервис и unit-файлы для этого сервиса.

Создаем файл с переменными  cat /etc/sysconfig/watchlog
WORD="ALERT"  
LOG=/var/log/watchlog.log

 Создаем /var/log/watchlog.log и пишем туда строки на своё усмотрение,  
плюс ключевое слово ‘ALERT’:  
This is a test log

This is sparta

Achtung alaram

Alert

ALERT

alarm Alert

test ALERT
Пишем скрипт /opt/watchlog.sh  
#!/bin/bash 
WORD=$1    
LOG=$2    
DATE=`date`    
if grep $WORD $LOG &> /dev/null    
then      
logger "$DATE: I found word, Master!"    
else    
exit 0    
fi    

Далее пишем unit (watchlog.service) для   в /etc/systemd/system    
[Unit]  
Description=My watchlog service  
[Service]  
Type=oneshot  
EnvironmentFile=/etc/sysconfig/watchdog  
ExecStart=/opt/watchlog.sh $WORD $LOG  

Создаем юнит (watclog.timer) для таймера в /etc/systemd/system  
[Unit]  
Description=Run watchlog script every 30 second  
[Timer]  
OnUnitActiveSec=30  
Unit=watchlog.service  
[Install]  
WantedBy=multi-user.target

Запускаем сервис
systemctl start watchlog.timer
![picture](https://github.com/Andrey874/manual_kernel_update/blob/master/HW7/watchlog.jpg)


### Задание 2.
#### Дополнить unit-файл сервиса httpd возможностью запустить несколько экземпляров сервиса с разными конфигурационными файлами.

В какталоге /usr/lib/systemd/system создаем файл httpd@.service путем копирования из исходного файла (httpd.service) и в получившемся файле добавялем -%I в конец строки EnvironmentFile=/etc/sysconfig/httpd

Создаем два файла
 /etc/sysconfig/httpd-first  
OPTIONS=-f conf/first.conf

/etc/sysconfig/httpd-second  
OPTIONS=-f conf/second.conf

В директории /etc/httpd/conf создаем файлы  first.conf и second.conf копированием из исходного (httpd.conf), во втором файле меняем порт на 8080 и путь  PidFile /var/run/httpd-second.pid

Запускаем первый и второй сервис
systemctl start httpd@first  
systemctl start httpd@second  
![picture1](https://github.com/Andrey874/manual_kernel_update/blob/master/HW7/httpd.jpg)

### Задание 3.
#### Создать unit-файл(ы) для сервиса:
#### - сервис: Kafka, Jira или любой другой, у которого код успешного завершения не равен 0 (к примеру, приложение Java или скрипт с exit 143);
#### - ограничить сервис по использованию памяти;
#### - ограничить сервис ещё по трём ресурсам, которые не были рассмотрены на лекции;
#### - реализовать один из вариантов restart и объяснить почему выбран именно этот вариант..

[zookeeper.service](https://github.com/Andrey874/manual_kernel_update/blob/master/HW7/zookeeper.service)
