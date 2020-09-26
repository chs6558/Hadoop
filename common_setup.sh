#!/bin/bash

install_JAVA="openjdk-8-jdk"
JAVAPATH="java-8-openjdk-amd64"
HADOOP="hadoop-3.2.1"

#step1
sudo apt install -y ssh
#step2
sudo apt install -y pdsh
echo "export PDSH_RCMD_TYPE=ssh" >> ~/.bashrc

#step3
ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa  # echo -e "\n"
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

#step4
sudo apt install -y $install_JAVA

#step5
sudo wget https://downloads.apache.org/hadoop/common/$HADOOP/$HADOOP.tar.gz
tar xzf $HADOOP.tar.gz
mv $HADOOP hadoop
sed -i 's/# export JAVA_HOME=/# export JAVA_HOME=\/usr\/lib\/jvm\/'$JAVAPATH'/g' ~/hadoop/etc/hadoop/hadoop-env.sh
sudo mv hadoop /usr/local/hadoop

#step6
sed -i 's;/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games;/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/local/hadoop/bin:/usr/local/hadoop/sbin;' /etc/environment
sudo echo JAVA_HOME=/usr/lib/jvm/$JAVAPATH/jre >> /etc/environment

#step7 create hadoopuser
sudo adduser hadoopuser --gecos ", , , ," --disabled-password
sudo echo "hadoopuser:hadoopuser" | chpasswd

#step8 hadoopuser config
sudo usermod -aG hadoopuser hadoopuser
sudo chown hadoopuser:root -R /usr/local/hadoop/
sudo chmod g+rws -R /usr/local/hadoop/
sudo adduser hadoopuser sudo

#step9 host regist
sudo ./read_setup_info.sh

#step10 my host config
sudo ./set_hostname.sh
#step 11
sudo reboot
