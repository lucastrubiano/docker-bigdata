# Dockerfile
# For Hive 3.1.3

#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

FROM ubuntu:mantic as unarchive

# Define environment variables

ENV HADOOP_VERSION=3.3.5

# Print version information

RUN echo "Hadoop version: $HADOOP_VERSION"

# Install dependencies

RUN set -ex; \
    apt-get update; \
    apt-get -y install wget; \
    rm -rf /var/lib/apt/lists/*

# Download and extract hadoop, hive and tez

WORKDIR /opt

RUN wget https://downloads.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz

# COPY hadoop-$HADOOP_VERSION.tar.gz /opt

RUN tar -xzvf /opt/hadoop-$HADOOP_VERSION.tar.gz -C /opt/ && \
    rm -rf /opt/hadoop-$HADOOP_VERSION/share/doc/*

# Build final image

FROM openjdk:8-jre-slim AS run

ENV HADOOP_VERSION=3.3.5

COPY --from=unarchive /opt/hadoop-$HADOOP_VERSION /opt/hadoop

# Install dependencies
RUN set -ex; \
    apt-get update; \
    apt-get -y install procps; \
    rm -rf /var/lib/apt/lists/*

# Set necessary environment variables.
ENV HADOOP_HOME=/opt/hadoop

ENV PATH=$HADOOP_HOME/bin:$PATH

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ARG UID=1000
RUN adduser --no-create-home --disabled-login --gecos "" --uid $UID hdfs && \
    chown hdfs /opt/hadoop && \
    mkdir -p /opt/hive/data/warehouse && \
    chown -R hive /opt/hive/data/warehouse && \
    $HADOOP_HOME/bin/hadoop fs -mkdir /tmp && \
    $HADOOP_HOME/bin/hadoop fs -mkdir /user/hive/warehouse && \
    $HADOOP_HOME/bin/hadoop fs -chmod g+w /tmp && \
    $HADOOP_HOME/bin/hadoop fs -chmod g+w /user/hive/warehouse

RUN adduser --no-create-home --disabled-login --gecos "" --uid $UID hive && \
    mkdir -p /opt/hive/data/warehouse && \
    chown -R hive /opt/hive/data/warehouse && \
    $HADOOP_HOME/bin/hadoop fs -mkdir /tmp && \
    $HADOOP_HOME/bin/hadoop fs -mkdir /user/hive/warehouse && \
    $HADOOP_HOME/bin/hadoop fs -chmod g+w /tmp && \
    $HADOOP_HOME/bin/hadoop fs -chmod g+w /user/hive/warehouse && \
    mkdir -p /home/hive/ && \
    chown -R hive /home/hive/ && \
    chmod 777 /home/hive/


# USER hive
# WORKDIR /opt/hive
# EXPOSE 10000 10002 9083
ENTRYPOINT ["sh", "-c", "/entrypoint.sh"]
