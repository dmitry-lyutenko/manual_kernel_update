##### Переименуем логический том:
`vgrename VolGroup00 OtusRoot`

##### В файлах  /etc/fstab, /etc/default/grub, /boot/grub2/grub.cfg
###### меняем VolGroup00 на OtusRoot

###### Пересоздаем образ initrd
 `mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)`

##### После того как команда отработает перезагрузиться.
