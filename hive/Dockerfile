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
ENV HIVE_VERSION=3.1.3
ENV TEZ_VERSION=0.9.2

# Print version information
RUN echo "Hive version: $HIVE_VERSION" && \
    echo "Tez version: $TEZ_VERSION"

# Install dependencies
RUN set -ex; \
    apt-get update; \
    apt-get -y install wget; \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt

# Download and extract hive and tez
RUN wget https://downloads.apache.org/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz && \
    wget https://downloads.apache.org/tez/$TEZ_VERSION/apache-tez-$TEZ_VERSION-bin.tar.gz

RUN tar -xzvf /opt/apache-hive-$HIVE_VERSION-bin.tar.gz -C /opt/ && \
    rm -rf /opt/apache-hive-$HIVE_VERSION-bin/jdbc/* && \
    tar -xzvf /opt/apache-tez-$TEZ_VERSION-bin.tar.gz -C /opt && \
    rm -rf /opt/apache-tez-$TEZ_VERSION-bin/share/*


# ========================
# Build final image
# ========================
FROM lucastrubiano/hadoop:hadoop_3_3_5

USER root

# Define environment variables
ENV HIVE_VERSION=3.1.3
ENV TEZ_VERSION=0.9.2

COPY --from=unarchive /opt/apache-hive-$HIVE_VERSION-bin /opt/hive
COPY --from=unarchive /opt/apache-tez-$TEZ_VERSION-bin /opt/tez

# Set necessary environment variables
ENV HIVE_HOME=/opt/hive \
    TEZ_HOME=/opt/tez

ENV PATH=$HIVE_HOME/bin:$TEZ_HOME/bin:$PATH

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ARG UID=1001

RUN adduser --no-create-home --disabled-login --gecos "" --uid $UID hive && \
    chown hive -R /opt/tez && \
    chown hive -R /opt/hive

RUN $HADOOP_HOME/bin/hadoop fs -mkdir -p /tmp/hive && \
    $HADOOP_HOME/bin/hadoop fs -mkdir -p /user/hive && \
    $HADOOP_HOME/bin/hadoop fs -chown -R hive /tmp/hive && \
    $HADOOP_HOME/bin/hadoop fs -chown -R hive /user/hive && \
    $HADOOP_HOME/bin/hadoop fs -chmod 777 /tmp/hive && \
    $HADOOP_HOME/bin/hadoop fs -chmod g+w /user/hive

USER hive

RUN $HADOOP_HOME/bin/hadoop fs -mkdir -p /user/hive/warehouse && \
    $HADOOP_HOME/bin/hadoop fs -chmod g+w /user/hive/warehouse

WORKDIR /opt/hive

EXPOSE 9083 10000 10002

# -dbType [derby|mysql|postgres|oracle|mssql]
# CMD ["$HIVE_HOME/bin/schematool", "-dbType", "derby", "-initSchema"]

ENTRYPOINT ["sh", "-c", "/entrypoint.sh"]