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

Далее пишем unit ([watchlog.service](https://github.com/Andrey874/manual_kernel_update/blob/master/HW7/watchlog.service)) в /etc/systemd/system    

Создаем юнит ([watclog.timer](https://github.com/Andrey874/manual_kernel_update/blob/master/HW7/watchlog.timer)) для таймера в /etc/systemd/system  

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

Для целей выполнения данного задания установлен сервис Kafka  
Юнит-файлы:  
[zookeeper.service](https://github.com/Andrey874/manual_kernel_update/blob/master/HW7/zookeeper.service)  
[kafka.service](https://github.com/Andrey874/manual_kernel_update/blob/master/HW7/kafka.service)

Реализован вариант перезагрузки Restart=on-failure. В данном случае при имитации сбоя сервиса kill -9 PID, сервис перезагруается самостоятельно.

Запуск сервиса
systemctl start kafka
![picture2](https://github.com/Andrey874/manual_kernel_update/blob/master/HW7/status1.jpg)

Имитируем сбой сервиса
![picture3](https://github.com/Andrey874/manual_kernel_update/blob/master/HW7/kill.jpg)

В течении 30-60 сек сервис восстанавливается
![picture4](https://github.com/Andrey874/manual_kernel_update/blob/master/HW7/statys2.jpg)
