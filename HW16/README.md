### Задание
#### Настраиваем центральный сервер для сбора логов
#### в вагранте поднимаем 2 машины web и log
#### на web поднимаем nginx
#### на log настраиваем центральный лог сервер на любой системе на выбор
#### - journald
#### - rsyslog
#### - elk
#### настраиваем аудит следящий за изменением конфигов нжинкса

#### все критичные логи с web должны собираться и локально и удаленно
#### все логи с nginx должны уходить на удаленный сервер (локально только критичные)
#### логи аудита должны также уходить на удаленную систему

1. На сервере log:  
в директорию /etc/rsyslog.d/ добавляем файл ([logs_from_web.conf](https://github.com/Andrey874/manual_kernel_update/blob/master/HW16/log/logs_from_web.conf)) для приема логов с web сервера.
Конфигурируем фалй /etc/rsyslog.conf, итоговый  конфиг   ([logs_from_web.conf](https://github.com/Andrey874/manual_kernel_update/blob/master/HW16/log/rsyslog.conf))

2. На сервере web:  
Для аудита конфигурационных файлов вводим комнду `auditctl -w /etc/nginx -p wa`  
В конфигурационный файл nginx.conf добавляем строки  
`error_log syslog:server=172.16.0.1:514,facility=local1,tag=error_nginx,severity=info;`  
`error_log /var/log/nginx/error.log crit;`
Итоговый файл ([nginx.conf](https://github.com/Andrey874/manual_kernel_update/blob/master/HW16/web/nginx.conf))  
Также добавляем в директорию /etc/rsyslog.d/ ([logs_forwarder.conf](https://github.com/Andrey874/manual_kernel_update/blob/master/HW16/web/logs_forwarder.conf))
 
