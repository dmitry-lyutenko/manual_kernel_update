##### Создать директорию 01test в /usr/lib/dracut/modules.d/
`mkdir /usr/lib/dracut/modules.d/01test`

##### В созданной директории создаем два скрипта
##### module-setup.sh:
`#!/bin/bash

check() {
    return 0
}

depends() {
    return 0
}

install() {
    inst_hook cleanup 00 "${moddir}/test.sh"
}`
##### и test.sh:
`#!/bin/bash

exec 0<>/dev/console 1<>/dev/console 2<>/dev/console
cat <<'msgend'
Hello! You are in dracut module!
 ___________________
< I'm dracut module >
 -------------------
   \
    \
        .--.
       |o_o |
       |:_/ |
      //   \ \
     (|     | )
    /\_   _/\
    \___)=(___/
msgend
sleep 10
echo " continuing...."`

##### Пересобираем образ initrd
`mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)`
