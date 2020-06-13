### Задание
#### 1) реализовать knocking port
#### - centralRouter может попасть на ssh inetrRouter через knock скрипт
#### пример в материалах
#### 2) добавить inetRouter2, который виден(маршрутизируется (host-only тип сети для виртуалки)) с хоста или форвардится порт через локалхост
#### 3) запустить nginx на centralServer
#### 4) пробросить 80й порт на inetRouter2 8080
#### 5) дефолт в инет оставить через inetRouter

Для реализации knocking port на inetRouter добавлены следующие правила:  
`-A INPUT -p tcp -m tcp --dport 22 -m state --state NEW -m recent --update --seconds 300 --hitcount 3 --name DEFAULT --rsource -j DROP`  
`-A INPUT -d 192.168.255.1/32 -p tcp -m tcp --sport 513:65535 --dport 22 -m state --state NEW,ESTABLISHED -m recent --set --name DEFAULT --rsource -j ACCEPT`  
`-A OUTPUT -s 192.168.255.1/32 -p tcp -m tcp --sport 22 --dport 513:65535 -m state --state ESTABLISHED -j ACCEPT`  

Для проброса портов на inetRouter2 добавлены селдующие правила  
`-A PREROUTING -d 10.0.2.15/32 -p tcp -m tcp --dport 8080 -j DNAT --to-destination 172.16.0.1:80`  
`-A OUTPUT -d 10.0.2.15/32 -p tcp -m tcp --dport 80 -j DNAT --to-destination 172.16.0.1`  
`-A POSTROUTING ! -d 192.168.0.0/16 -o eth1 -j MASQUERADE`  
`-A POSTROUTING -d 172.16.0.1/32 -p tcp -m tcp --dport 80 -j SNAT --to-source 192.168.255.6`  

Результат работы knocking port виден на следующем скриншоте

![picture1](https://github.com/Andrey874/manual_kernel_update/blob/master/HW20/knocking.jpg)

После нескольких вподряд запросов на подключение по ssh к inetRouter доступ временно заблокировался. 

#### Проброс портов
Вы полняем на inetRouter2 curl-запрос на локальный адрес и получаем ответ от сервиса nginx, находящегося на centralSrver по адресу 172.16.0.1
![picture2](https://github.com/Andrey874/manual_kernel_update/blob/master/HW20/pr.jpg)


