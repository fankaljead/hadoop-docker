FROM leidj/sqoop:1.0.2

MAINTAINER jeth <jeth123.github.com>

USER root

ENV ZOOKEEPER_HOME=/root/zookeeper
ENV PATH=$PATH:.:$ZOOKEEPER_HOME/bin

# 1. 安装 zookeeper 3.5.9
RUN wget https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/stable/apache-zookeeper-3.5.9-bin.tar.gz && \
        tar -xzvf apache-zookeeper-3.5.9-bin.tar.gz -C /root/ && \
    mv /root/apache-zookeeper-3.5.9-bin $ZOOKEEPER_HOME && \
        rm -rf apache-zookeeper-3.5.9-bin.tar.gz && \
        rm -rf $ZOOKEEPER_HOME/bin/*.cmd && \
        rm -rf $ZOOKEEPER_HOME/dist-maven && \
        rm -rf $ZOOKEEPER_HOME/docs && \
        rm -rf $ZOOKEEPER_HOME/src

# 开放2181端口
EXPOSE 2181

# 拷贝zookeeper配置文件
ADD config/zoo.cfg $ZOOKEEPER_HOME/conf/

# 拷贝HBase配置文件
ADD config/hbase/* /root/hbase/conf/

CMD ["sh", "-c", "service sshd start; $ZOOKEEPER_HOME/bin/zkServer.sh start; bash"]
