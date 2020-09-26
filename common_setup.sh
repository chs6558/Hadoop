install_JAVA="openjdk-8-jdk"
JAVAPATH="java-8-openjdk-amd64"
HADOOP="hadoop-3.2.1"

#step1
#apt install -y ssh
#step2
#apt install -y pdsh
echo "export PDSH_RCMD_TYPE=ssh" >> .bashrc

#step3
#ssh-keygen -t rsa -P "" | echo -e "\n"
#cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

#step4
#apt install -y $install_JAVA

#step5
#wget https://downloads.apache.org/hadoop/common/$HADOOP/$HADOOP.tar.gz
#tar xzf $HADOOP.tar.gz
#mv $HADOOP hadoop
#sed -i 's/# export JAVA_HOME=/# export JAVA_HOME=\/usr\/lib\/jvm\/'$JAVAPATH'/g' ~/hadoop/etc/hadoop/hadoop-env.sh
#mv hadoop /usr/local/hadoop

#step6
#sed -i 's;/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games;/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/local/hadoop/bin:/usr/local/hadoop/sbin;' /etc/environment
#echo JAVA_HOME=/usr/lib/jvm/$JAVAPATH/jre >> /etc/environment

#step7 create hadoopuser
#adduser hadoopuser --gecos ", , , ," --disabled-password
#echo "hadoopuser:hadoopuser" | chpasswd

#step8 hadoopuser config
usermod -aG hadoopuser hadoopuser
chown hadoopuser:root -R /usr/local/hadoop/
chmod g+rws -R /usr/local/hadoop/
adduser hadoopuser sudo
