
В директорию /usr/local/bin/ ложим скрипт - ([script.sh](https://github.com/Andrey874/manual_kernel_update/blob/master/HW9/script.sh))
Данный скрипт проводит проверку подключающегося пользователя на принадлежность к группе admin (gid1001) и текущий день (будни или выходной).
Далее добавляем в файл /etc/pam.d/login строку:   
account       requisite     pam_exec.so /usr/local/bin/script.sh  
Общий вид файла: ([login](https://github.com/Andrey874/manual_kernel_update/blob/master/HW9/login))  
Добавляем в файл /etc/pam.d/sshd строку: account       required    pam_exec.so /usr/local/bin/script.sh  
Общий вид файла: ([sshd](https://github.com/Andrey874/manual_kernel_update/blob/master/HW9/sshd))
