# **OTUS - Домашнее Задание #1**


**Цель:** Получить навыки работы с Git, Vagrant, Packer и публикацией готовых образов в Vagrant Cloud.

## **Задание**

Обновить ядро в базовой системе.

## **Ход выполнения**

### **Установка ПО для выполнения задания на ОС Linux Mint**

- **VirtualBox** 
```
apt-get install virtualbox
```
- **Vagrant** 
```
curl -O https://releases.hashicorp.com/vagrant/2.2.6/vagrant_2.2.6_x86_64.deb && \
sudo dpkg -i vagrant_2.2.6_x86_64.deb
```
- **Packer** 
```
curl https://releases.hashicorp.com/packer/1.4.4/packer_1.4.4_linux_amd64.zip | \
sudo gzip -d > /usr/local/bin/packer && \
sudo chmod +x /usr/local/bin/packer
```
- **Git**
```
apt-get install git
```
### **Клонирование и запуск ВМ**

- В GitHub под своей учеткой выполнена команда `fork` репозитория: https://github.com/dmitry-lyutenko/manual_kernel_update.
Репозиторий склонирован на на рабочую машину:
```
git clone git@github.com:ddeuterium/manual_kernel_update.git
```
- Запущена ВМ 
```
vagrant up
```
- Вход в ВМ и проверка текущего ядра
```
vagrant ssh
[vagrant@kernel-update ~]$ uname -r
3.10.0-957.12.2.el7.x86_64
```
### **Обновление ядра и загрузчика в запущенной ВМ:**

- Установлено ядро
```
sudo apt-get install yum
sudo yum install -y http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
sudo yum --enablerepo elrepo-kernel install kernel-ml -y
```
- Обновлена конфигурация загрузчика и выбрана загрузка с новым ядром по-умолчанию:
```
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
sudo grub2-set-default 0
```
- Перезагрузка:
```
sudo reboot
```
- Проверка версии ядра
```
uname -r
5.4.0-1.el7.elrepo.x86_64
```
### **Создание образа системы и его проверка**

- С помощью установленной утилиты packer создан свой образ системы, с уже скомпилированным и установленным 
ядром:

```
packer build centos.json
```

- Выполнен импорт созданного образа в Vagrant и проверка результатов сборки:
```
vagrant box add --name centos-7-5 centos-7.7.1908-kernel-5-x86_64-Minimal.box
vargant up
vagrant ssh
uname -r
```

- Произведена выгрузка созданного образа  в Vagrant Cloud: <https://app.vagrantup.com/ddeuterium/boxes/centos-7-5>
```
vagrant cloud publish --release Stump-D/centos-7-5 1.0 virtualbox / 
centos-7.7.1908-kernel-5-x86_64-Minimal.bo
```





# **ОШИБКИ**

## **Работа с Windows**

### **При выполнении скрипта под Windows возникает ошибка**

```
==> centos-7.7: Provisioning with shell script: scripts/stage-1-kernel-update.sh
   centos-7.7: >>> /etc/sudoers.d/vagrant: syntax error near line 1 <<<
   centos-7.7: sudo: parse error in /etc/sudoers.d/vagrant near line 1
   centos-7.7: sudo: no valid sudoers sources found, quitting
   centos-7.7: sudo: unable to initialize policy plugin
==> centos-7.7: Provisioning step had errors: Running the cleanup provisioner, if present...
```
решение мной не найдено 



