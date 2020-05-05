### Задание
#### Создайте свой кастомный образ nginx на базе alpine. После запуска nginx должен отдавать кастомную страницу (достаточно изменить   #### дефолтную страницу nginx) Определите разницу между контейнером и образом Вывод опишите в домашнем задании. Ответьте на вопрос:  #### Можно ли в контейнере собрать ядро? Собранный образ необходимо запушить в docker hub и дать ссылку на ваш репозиторий.
 В чем разница между контейнером и образом ?  
 Docker образ состоит из нескольких слоев в режиме read only. Контейнер состоит из слоя поверх docker образа в режиме read write.  
 Docker образ формируется на основе докерфайла. Контейнер запускается на основе образа.
 Контейнеры можно запускать, а docker образ нет. На основе docker образа запустить несколько контейнеров.  
 
Можно ли в контейнере собрать ядро?   
Ядро в контейнере собрать можно. Но при этом сниается скорость запуска контейнера, что также замедляет скрость обновления приложений в контейнере.  

### Приктическое задание.
Docker образ описан в  [Dockerfile](https://github.com/Andrey874/manual_kernel_update/blob/master/HW11/Dockerfile)  

Файл конфигурации nginx - [nginx.conf](https://github.com/Andrey874/manual_kernel_update/blob/master/HW11/nginx.conf)

Дефолтная страница - [index.html](https://github.com/Andrey874/manual_kernel_update/blob/master/HW11/index.html)

Сборка образа:
`sudo docker build -f Dockerfile -t andrey874/my_nginx .`

Запуск контейнера:
`sudo docker run -d -p 8080:8080 andrey874/my_nginx:latest`

Загрузка образа в Docker Hub:
`sudo docker push andrey874/my_nginx`

Ссылка на образ в Docker Hub:
https://hub.docker.com/repository/docker/andrey874/my_nginx
