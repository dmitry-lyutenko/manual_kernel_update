#!/bin/sh
LOCKFILE=/tmp/lockfile
if [ -e ${LOCKFILE} ] && kill -0 `cat ${LOCKFILE}`; then
   echo "alredy running"
   exit
fi
trap "rm -f ${LOCKFILE}; exit" INT TERM EXIT
echo $$ > ${LOCKFILE}

BACKUP_HOST='backup'
BACKUP_USER='root'
BACKUP_REPO='testborg'

echo $BACKUP_REPO

borg create --stats --progress ${BACKUP_USER}@${BACKUP_HOST}:${BACKUP_REPO}::"etc-{now:%Y-%m-%d_%H:%M:%S}" /etc 2>> /var/log/borg


borg prune -v --list ${BACKUP_USER}@${BACKUP_HOST}:${BACKUP_REPO} --keep-weekly=8 --keep-within=30d

rm -f ${LOCKFILE}
		
