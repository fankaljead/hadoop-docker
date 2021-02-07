#!/bin/bash

##############################################################
# 已经安装好 docker 和 docker-compose 的可以直接使用此脚本 ######
### 安装 hadoop 实验平台 ######################################
### fankaljead@gmail.com #####################################
##############################################################

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
docker pull zhouxianghui/azkasbt:v1.0.0
docker network create hadoop-docker
docker-compose up -d



echo '======sleeping 15s for service up========='
sleep 15s
docker cp ./volume/zk/hbase-master/hosts hbase-master:/etc/
docker-compose exec hbase-master hdfs namenode -format
docker-compose exec hbase-master schematool -dbType mysql -initSchema
echo '======sleeping 10s for creating table======='
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
echo "======starting azkaban solo jetty server====="
docker-compose exec hbase-master start-solo.sh
echo '======check zookeeper========================'
docker-compose exec hbase-master ./root/zookeeper/bin/zkServer.sh status
docker-compose exec hbase-slave1 ./root/zookeeper/bin/zkServer.sh status
docker-compose exec hbase-slave2 ./root/zookeeper/bin/zkServer.sh status
echo '======check sqoop==========================='
docker-compose exec hbase-master sqoop list-databases --connect jdbc:mysql://mysql:3306/ --username root --password hadoop
docker-compose exec hbase-master /bin/bash
