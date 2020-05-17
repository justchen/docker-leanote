#!/bin/bash

#init mongodb
. /etc/profile
mongod --dbpath  /data/db &

#loop until db start
while :
do
   netstat -ntlup | grep -w 27017
   [ $? -eq 0 ] && break
done


if [ ! -f "/data/db/do_not_delete" ]; then
	echo "Initial mongo data"
	mongorestore -h localhost -d leanote --dir /root/leanote/mongodb_backup/leanote_install_data/
	echo "do not delete this file" >> /data/db/do_not_delete
	chmod 400 /data/db/do_not_delete
fi

cp -n -r /root/leanote /data/
#rm -rf /root/leanote/*

echo `date "+%Y-%m-%d %H:%M:%S"`' >>>>>> start leanote service'
/data/leanote/bin/run.sh
