FROM twinsen/hbase:1.2.5

MAINTAINER leidj <leidjcqupt@gmail.com>

USER root

ENV SQOOP_HOME=/root/sqoop
ENV PATH=$PATH:.:$SQOOP_HOME/bin

# 1. 安装 SQOOP 1.4.7
RUN wget https://mirrors.tuna.tsinghua.edu.cn/apache/sqoop/1.4.7/sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz && \
		  tar -xzvf sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz -C /root/ && \
		  mv /root/sqoop-1.4.7.bin__hadoop-2.6.0 $SQOOP_HOME && \
		  rm -rf sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz && \
		  ln -s $HIVE_HOME/lib/mysql-connector-java-5.1.40-bin.jar $SQOOP_HOME/lib/mysql-connector-java-5.1.40-bin.jar && \
          rm -rf $SQOOP_HOME/bin/configure-sqoop && \
          rm -rf $SQOOP_HOME/conf/*
          

# 使用HBase下的Spark配置替换原始Spark配置文件
COPY config/sqoop/conf/sqoop-env.sh $SQOOP_HOME/conf/

COPY config/sqoop/conf/sqoop-site.xml $SQOOP_HOME/conf/

COPY config/sqoop/configure-sqoop $SQOOP_HOME/bin/

CMD [ "sh", "-c", "service sshd start; bash"]
