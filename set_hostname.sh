#!/bin/bash

MY_IP=$(hostname -I)
while read line
do
	Parse=($line)
	IP_info=${Parse[0]}
	Name_info=${Parse[1]}
	if [ $IP_info == $MY_IP ] ; then
		sed -i '1d' /etc/hostname
		echo $Name_info >> /etc/hostname
	fi
done < setup_info.txt

