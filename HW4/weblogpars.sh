#!/bin/sh
## Задание 
##написать скрипт для крона
##который раз в час присылает на заданную почту
##- X IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта
##- Y запрашиваемых адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта
##- все ошибки c момента последнего запуска
##- список всех кодов возврата с указанием их кол-ва с момента последнего запуска
##в письме должно быть прописан обрабатываемый временной диапазон
##должна быть реализована защита от мультизапуска
if [ -n "$1" ]
then
echo "OK"
else
echo "Ошибка! Не указан обязательный параметр! Укажите путь к лог файлу!"
echo $?
exit
fi
lockparser=/tmp/lockfilepars
if [ -f $lockparser ]
then 
    echo "Failed to acquire lockfile: $lockparser."
    echo "Held by $lockparser"
    exit 1
fi

sudo touch $lockparser
trap 'sudo rm -f "$lockparser"; exit &?' INT TERM EXIT
cat $1 | wc -l > /tmp/newcount 
if  [ -f /tmp/oldcount ]
then
old_count_string=`cat /tmp/oldcount` ## В каталоге /tmp создается два вспомогательных файла oldcount и newcount. При очередном запуске скрипта, в начале происходит подсчет количества строк в файле с логами и результат записывается в файл newcount, / 
                                     ##а также присваевается переменной new_count_string.
new_count_string=`cat /tmp/newcount` ## значение переменной new_count_string сравнивается со значением переменной old_count_string, которая берется из файла oldcount
else
sudo touch /tmp/oldcount $$ echo 1 > /tmp/oldcount
old_count_string=`cat /tmp/oldcount`
new_count_string=`cat /tmp/newcount`
fi
if [ "$new_count_string" -lt "$old_count_string" ] ## Если значение перемнной new_count_string меньше значения переменной old_count_string, то скрипт обрабатывает количестов строк соответствующее значению перемнной new_count_string
						   ## Если значение переменной new_count_string больше значения переменной old_count_string, то скрипт начинает обработку файла со следующей строки, относительно той, на которой закончил обработку / 
                                                   ##   файла с логами на предыдущем проходе.	
then
ip=$(awk  "NR<$new_count_string" $1 | awk '{ ipcount[$1]++ } END {for (i in ipcount) { printf "IP-%13s - %d \n", i, ipcount[i] } }' | awk -F"-" '{print $1, $2, $3}' | sort -nrk3 | sudo head -n5)
fqdnaddr=$(awk "NR<$new_count_string" $1 | awk 'match($0, /(https?):\/\/([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})/) { print substr( $0, RSTART, RLENGTH )}' \
|  awk '{ ipcount[$1]++ } END {for (i in ipcount) { printf "%13s - %d \n", i, ipcount[i] } }' | awk -F"-" '{print $1, $2}' | sort -nrk2  | \
 head -n3)
errors=$(awk "NR<$new_count_string"  $1 | cut -f9 -d ' ' | egrep -v '^"|^200|^301' | sort  | uniq)
codes=$(awk "NR<$new_count_string" $1 | cut -f9 -d ' ' | egrep -v '^"' | sort | awk '{ count[$1]++ } END {for (i in count) { print "\n", i, count[i] }}')  
startdate=$(awk "NR<$new_count_string" $1 | sed -n 1p | cut -f4 -d' ' | sed 's/\[//')
enddate=$(awk "NR>=$new_count_string" $1 | sed -n "$new_count_string"p | cut -f4 -d' ' | sed 's/\[//')
echo -e "Отчет за период: ${startdate} - $enddate\n IP-Адреса:\n $ip\n Доменные имена:\n $fqdnaddr\n Коды ошибок:\n $errors\n Кол-во кодов:\n $codes\n" |  sendmail  vagrant@localhost
sudo echo $new_count_string > /tmp/oldcount ## В конце работы скрипта значение перемнной old_count_string перезаписывается занчением переменной new_count_string
else
ip=$(awk  "NR>=$(($old_count_string+1))" $1 | awk '{ ipcount[$1]++ } END {for (i in ipcount) { printf "IP-%13s - %d \n", i, ipcount[i] } }' | awk -F"-" '{print $1, $2, $3}' | sort -nrk3 | sudo head -n5)
fqdnaddr=$(awk "NR>=$(($old_count_string+1))" $1 | awk 'match($0, /(https?):\/\/([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})/) { print substr( $0, RSTART, RLENGTH )}' \
|  awk '{ ipcount[$1]++ } END {for (i in ipcount) { printf "%13s - %d \n", i, ipcount[i] } }' | awk -F"-" '{print $1, $2}' | sort -nrk2  | \
sudo head -n3)
errors=$(awk "NR<$new_count_string" $1 | cut -f9 -d ' ' | egrep -v '^"|^200|^301' | sort | uniq) 
codes=$(awk "NR<$new_count_string" $1 | cut -f9 -d ' ' | egrep -v '^"' | sort | awk '{ count[$1]++ } END {for (i in count) { print "\n", i, count[i] }}') 
startdate=$(cat $1 | sed -n "$old_count_string"p | cut -f4 -d' ' | sed 's/\[//')
enddate=$(cat $1 | sed -n "$new_count_string"p | cut -f4 -d' ' | sed 's/\[//')
echo -e "Отчет за период: ${startdate} - $enddate\n IP-Адреса:\n $ip\n Доменные имена:\n $fqdnaddr\n Коды ошибок:\n $errors\n Кол-во кодов:\n $codes\n" |  sendmail vagrant@localhost
sudo echo $new_count_string > /tmp/oldcount
fi
sudo rm -f "$lockparser"
trap - INT TERM EXIT

