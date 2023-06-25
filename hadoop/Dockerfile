# Dockerfile
# For Hadoop 3.3.5

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

# Print versions
RUN echo "Hadoop version: $HADOOP_VERSION"

# Install dependencies
RUN set -ex; \
    apt-get update; \
    apt-get -y install wget; \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt

# Download and extract hadoop
RUN wget https://downloads.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz

RUN tar -xzvf /opt/hadoop-$HADOOP_VERSION.tar.gz -C /opt/ && \
    rm -rf /opt/hadoop-$HADOOP_VERSION/share/doc/*

# ========================
# Build final image
# ========================

FROM openjdk:8-jre-slim

ENV HADOOP_VERSION=3.3.5

COPY --from=unarchive /opt/hadoop-$HADOOP_VERSION /opt/hadoop

# Install dependencies
RUN set -ex; \
    apt-get update; \
    apt-get -y install procps;

# Install ssh and pdsh for Hadoop
RUN apt-get install -y --no-install-recommends ssh pdsh

# Remove apt cache
RUN rm -rf /var/lib/apt/lists/*

# Set necessary environment variables.
ENV HADOOP_HOME=/opt/hadoop

# Add Hadoop bin/ directory to PATH
ENV PATH=$HADOOP_HOME/bin:$PATH

ARG UID=1000

RUN adduser --no-create-home --disabled-login --gecos "" --uid $UID hadoop && \
    chown hadoop /opt/hadoop

USER hadoop

WORKDIR /opt/hadoop

RUN $HADOOP_HOME/bin/hadoop fs -mkdir -p /tmp && \
    $HADOOP_HOME/bin/hadoop fs -chmod g+w /tmp

# Expose ports.
#   - 50010: DataNode
#   - 50020: DataNode (secure)
#   - 50070: NameNode
#   - 50075: NameNode (secure)
#   - 50090: SecondaryNameNode
#   - 8020:  NameNode IPC
EXPOSE 50010 50020 50070 50075 50090 8020

# Define default command.
# CMD ["bash"]