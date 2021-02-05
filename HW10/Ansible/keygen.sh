#!/bin/bash
CURRENTDIR=$PWD
KEYNAME="id_rsa"
PASSPHRASE=""
if [ -f "$PWD/$KEYNAME" ] ;
        then
        echo "File $KEYNAME exist! Exiting."
        exit 0
	else
	ssh-keygen -q -t rsa -N "$PASSPHRASE" -f "$PWD/$KEYNAME"
fi
exit 0
