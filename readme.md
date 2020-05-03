# **Disclaimer**
The code provided here is not production-ready. This is my sandbox where I learn linux and other cool stuff.

# **HW_1 Base**
Image is built with packer/kernel-install/centos.json from iso and registered as https://app.vagrantup.com/Deriul/boxes/centos7.7_5.6.7

# **HW_1 \*(make kernel)**
## **Manual**
### Prepare config
I got my config from server with previously updated kernel from https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm
```
❯ scp -i /home/alx/gitz/manual_kernel_update/vagrant/starz/.vagrant/machines/kernel-make-1/virtualbox/private_key -P 2222 vagrant@127.0.0.1:/boot/config-5.6.9-1.el7.elrepo.x86_64 .config
```
### Make kernel
Building VM with vagrant/starz/vagrantfile from centos/7 and manually making the kernel
```
❯ scp -i /home/alx/gitz/manual_kernel_update/vagrant/starz/.vagrant/machines/kernel-make-2/virtualbox/private_key -P 2200 ./.config vagrant@127.0.0.1:/tmp/
```
```
sudo yum install wget zip unzip gpg -y && \
  cd /tmp/ && \
  wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.6.10.tar.xz && \
  unxz -v linux-5.6.10.tar.xz && \
  tar xvf linux-5.6.10.tar && \
  cp ./.config linux-5.6.10/
sudo yum groupinstall "Development Tools" -y && \
  sudo yum install ncurses-devel bison flex elfutils-libelf-devel openssl-devel bc -y
cd linux-5.6.10 && \
  sudo make -j $(nproc) && \
  sudo make modules
cd /tmp/ && \
  tar czf kernel.tar.gz linux-5.6.10
```
```
❯ scp -i /home/alx/gitz/manual_kernel_update/vagrant/starz/.vagrant/machines/kernel-make-2/virtualbox/private_key -P 2200 vagrant@127.0.0.1:/tmp/kernel.tar.gz ./.shared/kernel.tar.gz
```

### Install kernel
Remaking VM with vagrant/starz/vagrantfile from centos/7 and manually installing kernel from the previously made kernel.tar.gz
```
❯ scp -i /home/alx/gitz/manual_kernel_update/vagrant/starz/.vagrant/machines/kernel-make-1/virtualbox/private_key -P 2222 ./.shared/kernel.tar.gz vagrant@127.0.0.1:/tmp/
```
```
cd /tmp/ && tar xzf kernel.tar.gz
sudo make modules_install 
sudo make install
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
sudo grubby --set-default /boot/vmlinuz-5.6.10
sudo init 6
```
```
❯ uname -r
5.6.10
```
from https://www.cyberciti.biz/tips/compiling-linux-kernel-26.html

## **Automated**
Image is built with packer/kernel-make/centos.json from centos/7 and registered as

# **HW_1 \**(shared folders)**
To enable shared folders do locally
```
❯ vagrant plugin install vagrant-vbguest
```
and then add
```
config.vm.synced_folder "~/gitz/manual_kernel_update/.shared/", "/shared", type: "virtualbox"
```
to the vagrantfile (for more info take a look on https://www.vagrantup.com/docs/synced-folders/basic_usage.html)
