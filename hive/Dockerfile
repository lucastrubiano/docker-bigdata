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

FROM ubuntu as unarchive

# Define environment variables

ENV HADOOP_VERSION=3.3.5
ENV HIVE_VERSION=3.1.3
ENV TEZ_VERSION=0.9.2

# Print version information

RUN echo "Hadoop version: $HADOOP_VERSION" && \
    echo "Hive version: $HIVE_VERSION" && \
    echo "Tez version: $TEZ_VERSION"

# Install dependencies

RUN set -ex; \
    apt-get update; \
    apt-get -y install wget; \
    rm -rf /var/lib/apt/lists/*

# Download and extract hadoop, hive and tez

WORKDIR /opt

RUN wget https://downloads.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz && \
    wget https://downloads.apache.org/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz && \
    wget https://downloads.apache.org/tez/$TEZ_VERSION/apache-tez-$TEZ_VERSION-bin.tar.gz

# COPY hadoop-$HADOOP_VERSION.tar.gz /opt
# COPY apache-hive-$HIVE_VERSION-bin.tar.gz /opt
# COPY apache-tez-$TEZ_VERSION-bin.tar.gz /opt

RUN tar -xzvf /opt/hadoop-$HADOOP_VERSION.tar.gz -C /opt/ && \
    rm -rf /opt/hadoop-$HADOOP_VERSION/share/doc/* && \
    tar -xzvf /opt/apache-hive-$HIVE_VERSION-bin.tar.gz -C /opt/ && \
    rm -rf /opt/apache-hive-$HIVE_VERSION-bin/jdbc/* && \
    tar -xzvf /opt/apache-tez-$TEZ_VERSION-bin.tar.gz -C /opt && \
    rm -rf /opt/apache-tez-$TEZ_VERSION-bin/share/*

# Build final image

FROM openjdk:8-jre-slim AS run

ENV HADOOP_VERSION=3.3.5
ENV HIVE_VERSION=3.1.3
ENV TEZ_VERSION=0.9.2

COPY --from=unarchive /opt/hadoop-$HADOOP_VERSION /opt/hadoop
COPY --from=unarchive /opt/apache-hive-$HIVE_VERSION-bin /opt/hive
COPY --from=unarchive /opt/apache-tez-$TEZ_VERSION-bin /opt/tez

# Install dependencies
RUN set -ex; \
    apt-get update; \
    apt-get -y install procps; \
    rm -rf /var/lib/apt/lists/*

# Set necessary environment variables.
ENV HADOOP_HOME=/opt/hadoop \
    HIVE_HOME=/opt/hive \
    TEZ_HOME=/opt/tez

ENV PATH=$HIVE_HOME/bin:$HADOOP_HOME/bin:$PATH

COPY entrypoint.sh /
COPY conf $HIVE_HOME/conf
RUN chmod +x /entrypoint.sh

ARG UID=1000
RUN adduser --no-create-home --disabled-login --gecos "" --uid $UID hive && \
    chown hive /opt/tez && \
    chown hive /opt/hive && \
    chown hive /opt/hadoop && \
    chown hive /opt/hive/conf && \
    mkdir -p /opt/hive/data/warehouse && \
    chown -R hive /opt/hive/data/warehouse

USER hive
WORKDIR /opt/hive
EXPOSE 10000 10002 9083
ENTRYPOINT ["sh", "-c", "/entrypoint.sh"]
