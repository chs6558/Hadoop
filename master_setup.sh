#!/bin/bash

#step11 .bashrc edit
sudo su - hadoopuser -c 'echo "export PDSH_RCMD_TYPE=ssh" >> ~/.bashrc'

#step12 key gen
echo -e "\n" | sudo su - hadoopuser -c 'ssh-keygen -t rsa -P ""' 
while read line
do
	Parse=($line)
	Name_info=${Parse[1]}
	sudo su - hadoopuser -c "sshpass -p hadoopuser ssh-copy-id -o stricthostkeychecking=no hadoopuser@$Name_info"
done < setup_info.txt

#step13 core-site.xml edit
sudo sed -i "19 a <property><name>fs.defaultFS</name><value>hdfs://hadoop-main:9000</value></property>" /usr/local/hadoop/etc/hadoop/core-site.xml
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
#step 17
sudo su - hadoopuser -c "touch ~/hadoop-start.sh"
sudo su - hadoopuser -c "chmod 777 ~/hadoop-start.sh"
sudo su - hadoopuser -c "echo 'source /etc/environment' >> ~/hadoop-start.sh" 
sudo su - hadoopuser -c "echo 'hdfs namenode -format' >> ~/hadoop-start.sh"
sudo su - hadoopuser -c "echo 'start-dfs.sh' >> ~/hadoop-start.sh"
sudo su - hadoopuser -c "echo 'start-yarn.sh' >> ~/hadoop-start.sh"

sudo su - hadoopuser -c 'echo "export HADOOP_HOME=/usr/local/hadoop">> ~/.bashrc'
sudo su - hadoopuser -c 'echo "export HADOOP_COMMON_HOME=/usr/local/hadoop">> ~/.bashrc'
sudo su - hadoopuser -c 'echo "export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop">> ~/.bashrc'
sudo su - hadoopuser -c 'echo "export HADOOP_HDFS_HOME=/usr/local/hadoop">> ~/.bashrc'
sudo su - hadoopuser -c 'echo "export HADOOP_MAPRED_HOME=/usr/local/hadoop">> ~/.bashrc'
sudo su - hadoopuser -c 'echo "export HADOOP_YARN=/usr/local/hadoop">> ~/.bashrc'

sudo su - hadoopuser
