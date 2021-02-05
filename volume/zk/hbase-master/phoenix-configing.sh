#!/bin/bash

scp hbase/lib/phoenix-4.10.0-HBase-1.2-client.jar hbase-slave1.hadoop-docker:/root/hbase/lib
scp hbase/lib/phoenix-4.10.0-HBase-1.2-client.jar hbase-slave2.hadoop-docker:/root/hbase/lib
scp hbase/lib/phoenix-4.10.0-HBase-1.2-client.jar hbase-slave3.hadoop-docker:/root/hbase/lib


scp hbase/conf/hbase-site.xml hbase-slave1.hadoop-docker:/root/hbase/conf
scp hbase/conf/hbase-site.xml hbase-slave2.hadoop-docker:/root/hbase/conf
scp hbase/conf/hbase-site.xml hbase-slave3.hadoop-docker:/root/hbase/conf
