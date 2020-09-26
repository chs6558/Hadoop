#!/bin/bash

#step11 .bashrc edit
sudo su - hadoopuser -c 'echo "export PDSH_RCMD_TYPE=ssh" >> ~/.bashrc'

#step12 key gen
echo -e "\n" | sudo su - hadoopuser -c 'ssh-keygen -t rsa -P ""' 
while read line
do
	Parse=($line)
	Name_info=${Parse[1]}
	sudo su - hadoopuser -c "cat ~/.ssh/id_rsa.pub | ssh hadoopuser@$Name_info 'mkdir ~/.ssh; cat >> ~/.ssh/authorized_keys'"
done < setup_info.txt

#step13 core-site.xml edit
sudo sed -i "19 a <property><name>fs.defaultFS</name><value>hdfs://hadoop-master:9000</value></property>" /usr/local/hadoop/etc/hadoop/core-site.xml
#step14 hdfs-site.xml edit
sudo sed -i "19 a <property><name>dfs.namenode.name.dir</name><value>/usr/local/hadoop/data/nameNode</value></property><property><name>dfs.datanode.data.dir</name><value>/usr/local/hadoop/data/dataNoe></value></property><property><name>dfs.replication</name><value>2</value></property>" /usr/local/hadoop/etc/hadoop/hdfs-site.xml
#step15 worker edit
sudo sed -i '1d' /usr/local/hadoop/etc/hadoop/workers

while read line
do
	Parse=($line)
	if [ ${Parse[1]} != "hadoop-master" ] ; then
		sudo /bin/su -c "echo ${Parse[1]} >>  /usr/local/hadoop/etc/hadoop/workers"
	fi
done < setup_info.txt

#step16 scp hadoop file
while read line
do
	Parse=($line)
	if [ ${Parse[1]} != "hadoop-master" ] ; then
		echo ${Parse[1]}
		sudo su - hadoopuser -c "scp /usr/local/hadoop/etc/hadoop/* ${Parse[1]}:/usr/local/hadoop/etc/hadoop/"
	fi
done < setup_info.txt

sudo su - hadoopuser -c "source /etc/environment"
sudo su - hadoopuser -c "hdfs namenode -format"
sudo su - hadoopuser -c "start-dfs.sh"
