#!/bin/bash

# Update the system
sudo apt-get update
sudo apt-get upgrade -y

# Install required dependencies
sudo apt-get install -y ssh rsync

# Download Hadoop 1.2.1
wget https://archive.apache.org/dist/hadoop/core/hadoop-1.2.1/hadoop-1.2.1.tar.gz

# Extract the downloaded archive
tar -xzvf hadoop-1.2.1.tar.gz

# Move Hadoop to the desired installation directory
sudo mv hadoop-1.2.1 /usr/local/hadoop

# Set environment variables
echo 'export HADOOP_HOME=/usr/local/hadoop' >> ~/.bashrc
echo 'export PATH=$PATH:$HADOOP_HOME/bin' >> ~/.bashrc
source ~/.bashrc

# Configure Hadoop
cd $HADOOP_HOME

# Configure core-site.xml
cat << EOF > conf/core-site.xml
<configuration>
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://localhost:9000</value>
  </property>
</configuration>
EOF

# Configure hdfs-site.xml
cat << EOF > conf/hdfs-site.xml
<configuration>
  <property>
    <name>dfs.replication</name>
    <value>1</value>
  </property>
  <property>
    <name>dfs.namenode.name.dir</name>
    <value>file:/usr/local/hadoop_data/hdfs/namenode</value>
  </property>
  <property>
    <name>dfs.datanode.data.dir</name>
    <value>file:/usr/local/hadoop_data/hdfs/datanode</value>
  </property>
</configuration>
EOF

# Configure mapred-site.xml
cat << EOF > conf/mapred-site.xml
<configuration>
  <property>
    <name>mapred.job.tracker</name>
    <value>localhost:9001</value>
  </property>
</configuration>
EOF

# Configure yarn-site.xml
cat << EOF > conf/yarn-site.xml
<configuration>
  <property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
  </property>
  <property>
    <name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
    <value>org.apache.hadoop.mapred.ShuffleHandler</value>
  </property>
  <property>
    <name>yarn.resourcemanager.hostname</name>
    <value>localhost</value>
  </property>
</configuration>
EOF

# Format the Hadoop NameNode
bin/hadoop namenode -format

# Start Hadoop daemons
sbin/start-dfs.sh
sbin/start-yarn.sh

# Create directories for HDFS data nodes (adjust according to your setup)
sudo mkdir -p /usr/local/hadoop_data/hdfs/namenode
sudo mkdir -p /usr/local/hadoop_data/hdfs/datanode

# Set permissions
sudo chown -R $USER:$USER /usr/local/hadoop_data

# Print instructions for verification
echo "Hadoop 1.2.1 installation and configuration completed."
echo "You can access the Hadoop web interface at http://localhost:50070/"
echo "To run Hadoop MapReduce jobs, visit http://localhost:50030/"

### Before running the script, make sure to change the configuration according to your specific environment and setup. 
### After running the script, Hadoop should be installed and configured with a single NameNode and DataNode on the local machine. 
### You can access the Hadoop web interfaces at the URLs mentioned in the script's output.
