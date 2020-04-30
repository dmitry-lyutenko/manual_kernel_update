# **Disclaimer**
The code provided here is not production-ready. It is my sandbox where I learn linux and other cool stuff.

# **HW_1 Base**
Base image is built with packer/kernel-install/centos.json and registered
locally as centos/7.7_5.6.7
and remotely https://app.vagrantup.com/Deriul/boxes/centos7.7_5.6.7
```
❯ vagrant box list
centos/7         (virtualbox, 1905.1)
centos/7.7_5.6.7 (virtualbox, 0)
ubuntu/xenial64  (virtualbox, 20200428.0.0)
```
# **HW_1 \*(make kernel)**
## **Manual**
Building VM with vagrant/starz/vagrantfile from centos/7 and manually building the kernel
```
sudo yum install wget zip unzip gpg -y && \
  cd /tmp/ && \
  wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.6.8.tar.xz && \
  wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.6.8.tar.sign
unxz -v linux-5.6.8.tar.xz && \
  gpg --verify linux-5.6.8.tar.sign
gpg --recv-keys 6092693E
tar xvf linux-5.6.8.tar && \
  cp -v /boot/config-$(uname -r) .config && \
  sudo yum groupinstall "Development Tools" -y && \
  sudo yum install ncurses-devel bison flex elfutils-libelf-devel openssl-devel bc -y
cd linux-5.6.8 && \
  sudo make menuconfig
sudo make -j $(nproc)
```
```
sudo make modules_install 
sudo make install
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
sudo grubby --set-default /boot/vmlinuz-5.6.8
```
```
[vagrant@kernel-update ~]$ uname -r
5.6.8
```
from https://www.cyberciti.biz/tips/compiling-linux-kernel-26.html

## **Automated**
Base image is built with packer/kernel-make/centos.json

# **HW_1 \**(shared folders)**
To enable shared folders do
```
❯ vagrant plugin install vagrant-vbguest
```
and then add
```
config.vm.synced_folder "~/gitz/manual_kernel_update/.shared/", "/shared", type: "virtualbox"
```
to the vagrantfile (for more info take a look on https://www.vagrantup.com/docs/synced-folders/basic_usage.html)
