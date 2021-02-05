Создаем раид 5 с 3 дисками:
sudo mdadm --create --verbose /dev/md0 -l 5 -n 3 /dev/sd{b,c,d}
cat /proc/mdstat
mdadm -D /dev/md0


Ломаем один диск
sudo mdadm /dev/md0 --fail /dev/sdd
Удаляем диск
sudo mdadm --remove /dev/md0  /dev/sdd
Ставим обратно
sudo mdadm --add /dev/md0 /dev/sdd

Прописываем собраный рейд в конфигурацию
sudo mkdir mdadm
sudo touch mdadm.conf
sudo echo >> ARRAY /dev/md0 level=raid5 num-devices=3 metadata=1.2 name=otuslinux:0 UUID=c832d663:e724688c:f43a7e20:622e91e3

создаем раздел gpt на массиве дисков
sudo fdisk /dev/md0
в интерактивном режиме вводим g
затем w - записать и выйти

делаем 5 порций
sudo parted /dev/md0 mkpart primary ext4 0% 20%
sudo parted /dev/md0 mkpart primary ext4 20% 40%
sudo parted /dev/md0 mkpart primary ext4 40% 60%
sudo parted /dev/md0 mkpart primary ext4 60% 80%
sudo parted /dev/md0 mkpart primary ext4 80% 100%

Накатывем на них файловую систему
 sudo mkfs.ext4 /dev/md0p1
 sudo mkfs.ext4 /dev/md0p2
 sudo mkfs.ext4 /dev/md0p3
 sudo mkfs.ext4 /dev/md0p4
 sudo mkfs.ext4 /dev/md0p5

Монитруем порциии
sudo mount /dev/md0p1 /myraid5/part1
sudo mount /dev/md0p2 /myraid5/part2
sudo mount /dev/md0p3 /myraid5/part3
sudo mount /dev/md0p4 /myraid5/part4
sudo mount /dev/md0p5 /myraid5/part5

смортим blkid и прописываем в /etc/fstab в виде
uuid	/myraid5/part..		ext4 	defaults 0 0


cсылка на образ
https://app.vagrantup.com/Andrey874/boxes/centos-7-6/versions/1.0