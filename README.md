# docker-bigdata
Repositorio para crear en Docker un Cluster de Big Data basado en el ecosistema Hadoop

El Docker va a contener los siguientes servicios:
* **HDFS** (Hadoop Distributed File System)
    * **NameNode**
    * **DataNode**
* **YARN** (Yet Another Resource Negotiator)
    * **ResourceManager**
    * **NodeManager**
    * **HistoryServer**
* **Hive 3.1.3** (Hadoop Interactive Virtual Environment)
    * `Using Hadoop 3.3.5 and Tez 0.9.2`
    * **HiveServer2**
    * **Hive Metastore**
    * **Postgres 15.0** (for Metastore)
* **Hue 4.11.0** (Hadop User Experience)
* **Postgres 15.0** (like an OLTP database)
<!-- * **Spark**
    * **Master**
    * **Worker** -->
<!-- * Zeppelin -->
<!-- * Kafka -->
<!-- * Zookeeper -->
<!-- * HBase -->
<!-- * Phoenix -->
<!-- * Sqoop -->
<!-- * Oozie -->
<!-- * Flume -->
<!-- * MongoDB -->
<!-- * MySQL -->
<!-- * Cassandra -->