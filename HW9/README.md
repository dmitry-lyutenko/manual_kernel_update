### Задание
#### Запретить всем пользователям, кроме группы admin логин в выходные (суббота и воскресенье), без учета праздников  

В директорию /usr/local/bin/ ложим скрипт - ([script.sh](https://github.com/Andrey874/manual_kernel_update/blob/master/HW9/script.sh)).
Данный скрипт проводит проверку подключающегося пользователя на принадлежность к группе admin (gid1001) и текущий день (будни или выходной).  

Далее добавляем в файл /etc/pam.d/login строку:   
`account       required     pam_exec.so /usr/local/bin/script.sh`  
Общий вид файла: ([login](https://github.com/Andrey874/manual_kernel_update/blob/master/HW9/login))  

Добавляем в файл /etc/pam.d/sshd строку:  
`account       required    pam_exec.so /usr/local/bin/script.sh`  

Общий вид файла: ([sshd](https://github.com/Andrey874/manual_kernel_update/blob/master/HW9/sshd))  

Проверяем, что пользователь vagrant состоит в группе admin:  
![picture1](https://github.com/Andrey874/manual_kernel_update/blob/master/HW9/idvagrant.jpg)  

Пользователь test1 не входит в данную группу:
![picture2](https://github.com/Andrey874/manual_kernel_update/blob/master/HW9/idtest1.jpg)  

В будний день пользователь test1 подключается по ssh  
![picture3](https://github.com/Andrey874/manual_kernel_update/blob/master/HW9/sshtest1.jpg)  
Меняем дату на хосте на выходной день, в данном примере суббота:  
![picture4](https://github.com/Andrey874/manual_kernel_update/blob/master/HW9/changedate.jpg)  

Проверяем подключение пользователя test1 через консоль и ssh  

![picture5](https://github.com/Andrey874/manual_kernel_update/blob/master/HW9/sshtest1err.jpg)  

![pictur6](https://github.com/Andrey874/manual_kernel_update/blob/master/HW9/test1err.jpg)

Пользователь vagrant, входящий в группу admin поключается без проблем:  

![pictur7](https://github.com/Andrey874/manual_kernel_update/blob/master/HW9/vagrantok.jpg)  

