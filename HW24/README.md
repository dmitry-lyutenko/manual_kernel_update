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

### Создание ключей и сертификатов для клиента  

./easyrsa gen-req vpnclient nopass # В результате выполнения данной команнды получем файл vpnclient.key  
Аргументы программы easyrsa:   
gen-req — сгененрировать запрос на выпуск сертификата;   
vpnclient — описательное имя клиента;   
nopass — ключ без пароля.  

Импортировать полученный от клиента запрос на выпуск сертификата:  
./easyrsa import-req pki/reqs/vpnclient.req vpnclient    
Аргументы программы easyrsa:   
import-req — импортировать требование;   
pki/reqs/vpnclient.req — абсолютный путь к файлу требования;   
vpnclient — описательное имя клиента.  
Программа напечатает абсолютный путь к импортированному файлу требования:  
`Existing file at: /root/easy-rsa/pki/reqs/vpnclient.req`

Подписать запрос (выпустить и подписать сертификат):  
root@intgate:~/easy-rsa# ./easyrsa sign-req client vpnclient  

Аргументы программы easyrsa:   
sign-req — подписать запрос;   
client — тип запроса; server или client, соответственно;   
vpnclient — описательное имя клиента.  
Потребует ввести yes для подтверждения доверия к запросу, и если при создании ЦС был задан пароль к ключу,   
то программа ещё и потребует ввести пароль. В заключение напечатает абсолютный путь к файлу подписанного сертификата:  
`Certificate created at: /root/easy-rsa/pki/issued/vpnclient.crt`  
Итого на клиентскоую сторону необходимо передать следующие файлы:  
ca.crt vpnclient.crt vpnclient.key dh.pem ta.key  

## Настройка конфигурационного файла vpnserver  

> local 10.100.100.3   *# На каком интерфейсе работает OpenVPN*  
> port 1194             # Стандартный порт   
> proto udp             # Использовать UDP. Лучше защищён # от DOS-атак и сканирования   
> ;proto tcp            # Использовать TCP   
> dev tun               # Если UDP   
> ;dev tap              # Если TCP
> ; explicit-exit-notify 0  # Раскомментировать, если TCP  
> #Местоположение ключей, сертификатов и последовательности Диффи-Хэллмана   
> ca /etc/openvpn/server/ca.crt   
> cert /etc/openvpn/server/centre.crt   
> key /etc/openvpn/server/centre.key
> dh /etc/openvpn/server/dh.pem  
> #IP и маска виртуальной сети. Работает только с TLS клиентами в режиме tun.  
> server 192.168.12.0 255.255.255.0 # Клиенты будут получать IP в диапазоне от 192.168.12.2 до 192.168.12.254  
> client-config-dir ccd # Каталог в /etc/openvn, где хранятся файлы с настройками IP клиентов.  
> ifconfig-pool-persist ipp.txt # Файл, в котором будут сохраняться динамически выданные адреса для VPN-клиентов. При последующих подключениях назначать те же самые адреса. 
> #Cети, в которые нужно идти через туннель.   
> ;push "route 10.100.100.0 255.255.255.0"
> tls-server               # Включение TLS в роли серврера  
> tls-auth /etc/openvpn/server/ta.key 0    # Файл секрета. Ноль в конце должен быть на сервере; у клиента единица.     
> key-direction 0          # Аналогично: на сервере ноль; у клиента единица. 
> tls-timeout 120 
> auth SHA256               # Алгоритм хэширования при аутентификации   
> cipher AES-256-CBC        # Алгоритм шифрования траффика
> ;client-to-client         # Топология "звезда", и сервер станет её центром, а клиенты будут "видеть" друг друга.   
> keepalive 10 120          # Рассылка уведомлений "я жив", чтобы при отсутствии траффика удалённая сторона не закрывала соединение. ping каждые 10 секунд, если отклика    
                            #нет в течение 120 с., - рестарт # сессии. 
> comp-lzo                  # Адаптивная компрессия. Значение по умолчанию adaptive. Принудительное вкл.сжатия yes Принудительное откл.сжатия --- no  
> max-clients 10              # Максимальное число клиентов
> user nobody   
> group nogroup  
> persist-key                 # Не перечитывать ключи ...
> persist-tun                 # не изменять TUN или TAP устройство при рестарте туннеля.   
> status openvpn-status.log   
> log /var/log/openvpn.log   
> verb 3                        # Нормальный уровень многословности   
> mute 20                       # Максимум 20 одинаковых сообщений подряд
> #Если туннель используется для клиента как маршрут по умолчанию   
> ;push "redirect-gateway def1 bypass-dhcp"   
> ;push "dhcp-option DNS ip.addr.dns.serv"   
> ;push "dhcp-option DOMAIN skynet.com.local" 









