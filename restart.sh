#!/bin/bash


########################################
### 虚拟机关机后 使用此脚本 可以重启容器###
### fankaljead@gmail.com ###############
########################################

docker-compose start


echo '======restarting for service up========='
# sleep 15s
# docker-compose exec hbase-master hdfs namenode -format
# docker-compose exec hbase-master schematool -dbType mysql -initSchema
# echo '======sleeping 10s for creating table======='
# sleep 10s
# docker-compose exec hbase-master jar cv0f /code/spark-libs.jar -C /root/spark/jars/ .
# docker-compose exec hbase-master start-dfs.sh
# docker-compose exec hbase-master hadoop fs -mkdir -p /user/spark/share/lib/
# docker-compose exec hbase-master hadoop fs -put /code/spark-libs.jar /user/spark/share/lib/
docker-compose exec hbase-master stop-dfs.sh
docker-compose exec hbase-master start-dfs.sh
docker-compose exec hbase-master start-yarn.sh
docker-compose exec hbase-master start-all.sh
docker-compose exec hbase-master stop-hbase.sh
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
