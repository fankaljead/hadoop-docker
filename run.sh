#!/bin/bash

########################################
#### Hadoop-Docker 一键安装脚本 #########
### 安装 docker ########################
### 安装 docker-compose ################
### 安装 hadoop 实验平台 ################
### fankaljead@gmail.com ###############
########################################

echo '============================================================='
echo '===Welcome to Big Data Analysis Auto Installation Sctipt====='
echo '=== Chongqing University of Posts and Telecommunications ===='
echo 'Big Data Analysis and Processing Course By leidj@cqupt.edu.cn'
echo '============================================================='

# Install Docker With Offitial Script
if hash docker 2>/dev/null;
then
    echo "docker has been already installed"
else
    edition=`awk -F= '/^NAME/{print $2}' /etc/os-release`
    if [[ $edition =~ "CentOS Linux" ]]; then
        echo "Your system is Centos"
        echo "Installing Docker"
        sudo yum -y install yum-utils curl vim git wget
        # yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        # yum-config-manager \
        #     --add-repo \
        #     https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/docker-ce.repo
        sudo yum-config-manager \
            --add-repo \
            http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
        sudo yum install -y docker-ce-18.03.1.ce
    elif [[ $edition =~ "Ubuntu" ]]; then
        echo "Your system is Ubuntu"
        sudo apt install curl wget vim git -y 
        
        sudo curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
    fi
    
    # Copy the mirror configuration to /etc/docker
    echo 'Adding mirror acceleration'
    sudo mkdir -p /etc/docker
    # cat >>daemon.json<<EOF
    # {
    #    "registry-mirrors": ["https://0pjd7q4y.mirror.aliyuncs.com"]
    # }
    # EOF

    sudo cat >> /etc/daemon.json <<EOF
    {
       "registry-mirrors": ["https://0pjd7q4y.mirror.aliyuncs.com"]
    }
    EOF

    sudo groupadd docker
    sudo usermod -aG docker lab

    sudo systemctl daemon-reload
    sudo systemctl restart docker
fi



# Install Zip
if hash unzip 2>/dev/null;
then
    echo "zip has been already installed"
else
    edition=`awk -F= '/^NAME/{print $2}' /etc/os-release`
    if [[ $edition =~ "CentOS Linux" ]]; then
        echo "Installing zip"
        echo "Your system is Centos"
	sudo yum install -y zip
    elif [[ $edition =~ "Ubuntu" ]]; then
        echo "Installing zip"
        echo "Your system is Ubuntu"
        sudo apt install zip -y
    fi
fi



# Install Docker-compose
if hash docker-compose 2>/dev/null;
then
    echo "docker-compose has already installed"
else
    echo "Installing Docker-compose"
    sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
fi


#wget https://github.com/jeth123/hadoop-docker/archive/1.2.5.zip 
#wget https://github.com/fankaljead/hadoop-docker/archive/2.0.0.zip
# Unzip Hadoop-docker.zip
#chmod 777 1.2.5.zip
#unzip 2.0.0.zip
#cd hadoop-docker-2.0.0


# Pull Some Docker Images
docker pull mysql:5.7
docker pull centos:7
docker pull twinsen/os-jvm:centos6-openjdk8
docker pull twinsen/hadoop:2.7.2
docker pull twinsen/hive:2.1.1
docker pull twinsen/spark:2.3.0
docker pull twinsen/hbase:1.2.5
docker pull leidj/sqoop:1.0.2
docker pull jeth123/zk:1.0.2
docker pull zhouxianghui/azkasbt:1.0.1
docker network create hadoop-docker
docker-compose up -d


echo 'sleeping 15s for service up'
sleep 15s
docker cp ./volume/zk/hbase-master/hosts hbase-master:/etc/
docker-compose exec hbase-master ./root/phoenix-configing.sh
docker-compose exec hbase-master hdfs namenode -format
docker-compose exec hbase-master schematool -dbType mysql -initSchema
echo 'sleeping 10s for creating table'
sleep 10s
docker-compose exec hbase-master jar cv0f /code/spark-libs.jar -C /root/spark/jars/ .
docker-compose exec hbase-master start-dfs.sh
docker-compose exec hbase-master hadoop fs -mkdir -p /user/spark/share/lib/
docker-compose exec hbase-master hadoop fs -put /code/spark-libs.jar /user/spark/share/lib/
docker-compose exec hbase-master stop-dfs.sh
docker-compose exec hbase-master start-dfs.sh
docker-compose exec hbase-master start-yarn.sh
docker-compose exec hbase-master start-all.sh
docker-compose exec hbase-master start-hbase.sh
docker-compose exec hbase-master start-solo.sh

echo 'check zookeeper'
docker-compose exec hbase-master ./root/zookeeper/bin/zkServer.sh status
docker-compose exec hbase-slave1 ./root/zookeeper/bin/zkServer.sh status
docker-compose exec hbase-slave2 ./root/zookeeper/bin/zkServer.sh status
echo 'check sqoop'
docker-compose exec hbase-master sqoop list-databases --connect jdbc:mysql://mysql:3306/ --username root --password hadoop

echo "Hbase master JPS"
docker-compose exec hbase-master jps
docker-compose exec hbase-master /bin/bash
