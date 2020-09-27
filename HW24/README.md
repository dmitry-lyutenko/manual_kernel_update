## Настройка vpnserver и центра сертификации 
### Для системы CentOS

yum install -y epel-release  
yum install -y openvpn easy-rsa  
Перейти в директорию /usr/share/easy-rsa/3.0.3/easyrsa  
Инициировать инфраструктуру открытых ключей:  
./easyrsa init-pki  
В результате будет создан каталог /root/easy-rsa/pki.
Создать ключ и корневой сертификат ЦС:  
./easyrsa build-ca nopass  #Аргумент nopass означает, что у ключа не будет пароля  
В процессе работы программа попросит пользователя ввести доменное имя ЦС — CN  
`Common Name (eg: your user, host, or server name) [Easy-RSA CA]:`

В результате будут созданы ключ и корневой сертификат ЦС (ca.crt и ca.key)

Создание ключа сервера и запрос на выпуск сертификата к нему:  

./easyrsa gen-req vpnserver nopass  
Программа потребует ввести FQDN имя сервера и сообщит местоположение созданного ключа и запроса на выпуск сертификата. 
Аргументы программы easyrsa:   
gen-req — сгенерировать запрос на выпуск сертификата;   
vpnserver — описательное имя сервера;   
nopass — ключ без пароля.
Скопировать ключ сервера в конфигурационный каталог OpenVPN:  
cp pki/private/vpnserver.key /etc/openvpn/server/  

Выпустить и подписать сертификат:  
./easyrsa sign-req server vpnserver  
Аргументы программы easyrsa:   
sign-req — подписать запрос;   
server — тип запроса; server или client, соответственно;   
vpnsever - описательное имя сервера. 
Программа потребует ввести yes для подтверждения доверия к запросу.  

В результате будут созданы файлы pki/issued/centre.crt pki/ca.crt, которые необходимо скопировать в каталог /etc/openvpn/server/  

Генерация последовательности Диффи-Хэллмана:  
./easyrsa gen-dh  
Результатом будет:  
`DH parameters of size 2048 created at /root/easy-rsa/pki/dh.pem`  

Cгененрировать ключ для TLS-аутентификации:  
openvpn --genkey --secret ta.key   
dh.pem и ta.key также необходимо перенести в /etc/openvpn/server/  









