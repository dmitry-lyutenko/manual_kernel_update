sudo yum install xfsdump

# 1. уменьшить том / до 8G

`sudo pvcreate /dev/sdb`  

`sudo vgcreate vg_root /dev/sdb`  

`sudo lvcreate -n lv_root -l +100%FREE /dev/vg_root`

`sudo mkfs.xfs /dev/vg_root/lv_root`  

`sudo mount /dev/vg_root/lv_root /mnt`  

`sudo xfsdump -J - /dev/VolGroup00/LogVol00 | sudo xfsrestore -J - /mnt`  

`for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt/$i; done`  

`sudo chroot /mnt/`  

`sudo grub2-mkconfig -o /boot/grub2/grub.cfg`  

cd /boot ; for i in \`ls initramfs-*img\`; do dracut -v $i \`echo $i|sed "s/initramfs-//g; s/.img//g"\` --force; done  


выйти из системы, зайти снова и перезагрузиться

sudo lvremove /dev/VolGroup00/LogVol00  

sudo lvcreate -n VolGroup00/LogVol00 -L 8G /dev/VolGroup00  

sudo mkfs.xfs /dev/VolGroup00/LogVol00  

sudo mount /dev/VolGroup00/LogVol00  /mnt  

sudo xfsdump -J - /dev/vg_root/lv_root | sudo xfsrestore -J - /mnt  

for i in /proc/ /sys/ /dev/ /run/ /boot/; do sudo mount --bind $i /mnt/$i; done  

sudo chroot /mnt/  

sudo grub2-mkconfig -o /boot/grub2/grub.cfg  

cd /boot; for i in \`ls initramfs-*img\`; do dracut -v $i \`echo $i | sed "s/initramfs-//g;s/.img//g"\` --force; done  


# 2. выделить том под /var

sudo pvcreate /dev/sdc/ /dev/sdd  

sudo vgcreate vg_var /dev/sdc /dev/sdd  


# 3./var - сделать в mirror

sudo lvcreate -L 950M -m1 -n lv_var vg_var  

sudo mkfs.ext4 /dev/vg_var/lv_var  

sudo mount /dev/vg_var/lv_var /mnt  

sudo cp -aR /var/* /mnt  

sudo mkdir /tmp/oldvar && sudo mv /var/* /tmp/oldvar  


# 4. прописать монтирование в fstab  

sudo echo "\`blkid | grep var: | awk '{print $2}'\` /var ext4 defaults 0 0" >> /etc/fstab  


выйти из системы, зайти снова и перезагрузиться

sudo lvremove /dev/vg_root/lv_root  

sudo vgremove /dev/vg_root  

sudo pvremove /dev/sdb  


# 5. выделить том под /home

sudo lvcreate -n LogVol_Home -L 2G /dev/VolGroup00  

sudo mkfs.xfs /dev/VolGroup00/LogVol_Home  

sudo mount /dev/VolGroup00/LogVol_Home /mnt  

sudo cp -aR /home/* /mnt/  

 sudo rm -rf /home/*  
 
sudo umount /mnt  

sudo mount /dev/VolGroup00/LogVol_Home /home/  

sudo echo "\`blkid | grep HOME | awk '{print $2}'\` /home xfs defaults 0 0" >> /etc/fstab

# 6. /home - сделать том для снэпшотов

sudo lvcreate -L 100MB -s -n home_snap /dev/VolGroup00/LogVol_Home

# 7. - сгенерить файлы в /home/

###### - снять снэпшот  

###### - удалить часть файлов  

###### - восстановится со снэпшота  

sudo touch /home/file{1..20}  

sudo rm -f /home/file{11..20}  

sudo lvconvert --merge /dev/VolGroup00/home_snap  

sudo mount /home

Ссылка на образ
https://app.vagrantup.com/Andrey874/boxes/centos-7
