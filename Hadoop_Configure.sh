#!/bin/bash

# Hadoop installation directory
HADOOP_HOME="/path/to/hadoop-1.2.1"

# Namenode hostname
NAMENODE_HOST="namenode.example.com"

# Array of DataNode hostnames
DATANODE_HOSTS=("datanode1.example.com" "datanode2.example.com")

# Configure HDFS client
echo "Configuring Hadoop HDFS client..."
echo "export HADOOP_CONF_DIR=$HADOOP_HOME/conf" >> ~/.bashrc
source ~/.bashrc

# Configure NameNode
echo "Configuring Hadoop NameNode..."
cp $HADOOP_HOME/conf/core-site.xml.template $HADOOP_HOME/conf/core-site.xml
echo "<configuration>" > $HADOOP_HOME/conf/core-site.xml
echo "  <property>" >> $HADOOP_HOME/conf/core-site.xml
echo "    <name>fs.defaultFS</name>" >> $HADOOP_HOME/conf/core-site.xml
echo "    <value>hdfs://$NAMENODE_HOST:9000</value>" >> $HADOOP_HOME/conf/core-site.xml
echo "  </property>" >> $HADOOP_HOME/conf/core-site.xml
echo "</configuration>" >> $HADOOP_HOME/conf/core-site.xml

cp $HADOOP_HOME/conf/hdfs-site.xml.template $HADOOP_HOME/conf/hdfs-site.xml
echo "<configuration>" > $HADOOP_HOME/conf/hdfs-site.xml
echo "  <property>" >> $HADOOP_HOME/conf/hdfs-site.xml
echo "    <name>dfs.replication</name>" >> $HADOOP_HOME/conf/hdfs-site.xml
echo "    <value>3</value>" >> $HADOOP_HOME/conf/hdfs-site.xml
echo "  </property>" >> $HADOOP_HOME/conf/hdfs-site.xml
echo "</configuration>" >> $HADOOP_HOME/conf/hdfs-site.xml

echo "$NAMENODE_HOST" > $HADOOP_HOME/conf/masters

# Configure DataNodes
echo "Configuring Hadoop DataNodes..."
cp $HADOOP_HOME/conf/core-site.xml.template $HADOOP_HOME/conf/core-site.xml
echo "<configuration>" > $HADOOP_HOME/conf/core-site.xml
echo "  <property>" >> $HADOOP_HOME/conf/core-site.xml
echo "    <name>fs.defaultFS</name>" >> $HADOOP_HOME/conf/core-site.xml
echo "    <value>hdfs://$NAMENODE_HOST:9000</value>" >> $HADOOP_HOME/conf/core-site.xml
echo "  </property>" >> $HADOOP_HOME/conf/core-site.xml
echo "</configuration>" >> $HADOOP_HOME/conf/core-site.xml

cp $HADOOP_HOME/conf/hdfs-site.xml.template $HADOOP_HOME/conf/hdfs-site.xml
echo "<configuration>" > $HADOOP_HOME/conf/hdfs-site.xml
echo "  <property>" >> $HADOOP_HOME/conf/hdfs-site.xml
echo "    <name>dfs.datanode.data.dir</name>" >> $HADOOP_HOME/conf/hdfs-site.xml
echo "    <value>/path/to/data/directory</value>" >> $HADOOP_HOME/conf/hdfs-site.xml
echo "  </property>" >> $HADOOP_HOME/conf/hdfs-site.xml
echo "</configuration>" >> $HADOOP_HOME/conf/hdfs-site.xml

echo "" > $HADOOP_HOME/conf/slaves
for host in "${DATANODE_HOSTS[@]}"; do
  echo "$host" >> $HADOOP_HOME/conf/slaves
done

# Format HDFS on the NameNode
echo "Formatting HDFS on the NameNode..."
$HADOOP_HOME/bin/hadoop namenode -format

echo "Hadoop configuration completed!"

### Make sure to replace the following variables with appropriate values:
### /path/to/hadoop-1.2.1: Path to the Hadoop 1.2.1 installation directory.
### namenode.example.com: Hostname of the NameNode.
### datanode1.example.com, datanode2.example.com: Hostnames of the DataNodes.
### /path/to/data/directory: Path to the directory where the DataNodes will store data.
### Save the script to a file, e.g., configure_hadoop.sh, and make it executable using "chmod +x configure_hadoop.sh". 
### Then, you can execute the script using "./configure_hadoop.sh" on the respective nodes to configure Hadoop.
