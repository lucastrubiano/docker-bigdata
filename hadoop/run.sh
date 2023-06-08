# run.sh

# namenode

docker run --name namenode -it -p 9870:9870 lucastrubiano/hadoop:hadoop_3_3_5 /bin/bash

docker cp ./hadoop/conf/core-site.xml namenode:/opt/hadoop/etc/hadoop/core-site.xml

docker exec -it namenode /bin/bash

# as root user
# docker exec -it -u 0 namenode /bin/bash

$HADOOP_HOME/bin/hdfs namenode -format

$HADOOP_HOME/bin/hdfs --daemon start namenode

# Logs at $HADOOP_LOG_DIR (default: $HADOOP_HOME/logs)

tail -f $HADOOP_HOME/logs/hadoop-hadoop-namenode-*.log


# datanode

docker run --name datanode -it lucastrubiano/hadoop:hadoop_3_3_5 /bin/bash

docker cp ./hadoop/conf/core-site.xml datanode:/opt/hadoop/etc/hadoop/core-site.xml

docker exec -it datanode /bin/bash

# as root user
# docker exec -it -u 0 datanode /bin/bash

$HADOOP_HOME/bin/hdfs --daemon start datanode

# Logs at $HADOOP_LOG_DIR (default: $HADOOP_HOME/logs)

tail -f $HADOOP_HOME/logs/hadoop-root-datanode-*.log

# yarn

docker run --name yarn -it lucastrubiano/hadoop:hadoop_3_3_5 /bin/bash -p 8088:8088 -p 19888:19888

docker cp ./hadoop/conf/core-site.xml yarn:/opt/hadoop/etc/hadoop/core-site.xml

docker exec -it yarn /bin/bash

# as root user
# docker exec -it -u 0 yarn /bin/bash

$HADOOP_HOME/bin/yarn --daemon start resourcemanager

$HADOOP_HOME/bin/yarn --daemon start nodemanager

$HADOOP_HOME/bin/yarn --daemon start proxyserver

$HADOOP_HOME/bin/mapred --daemon start historyserver