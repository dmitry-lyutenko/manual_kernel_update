#!/bin/bash
id $PAM_USER | cut -f3 -d" " | grep 1001
i=$?
if [ $i == 0 ];
then

exit 0
elif [[ `date +%u` > 5 ]];
then

exit 1

exit 0
fi
