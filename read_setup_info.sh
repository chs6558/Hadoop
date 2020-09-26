#!/bin/bash
while read line
do
	sed -i "3 a $line" /etc/hosts
done < setup_info.txt
