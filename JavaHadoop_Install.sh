#!/bin/bash

# Update the system
sudo yum update -y

# Install Java Development Kit (JDK)
sudo yum install -y java-1.8.0-openjdk-devel

# Verify Java installation
java -version

# Download and install Hadoop 1.2.1
HADOOP_VERSION="1.2.1"
HADOOP_URL="https://archive.apache.org/dist/hadoop/core/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz"
INSTALL_DIR="/opt/hadoop"

# Create installation directory
sudo mkdir -p "$INSTALL_DIR"
sudo chown -R $USER:$USER "$INSTALL_DIR"

# Download and extract Hadoop
wget "$HADOOP_URL" -P /tmp
tar -xf "/tmp/hadoop-$HADOOP_VERSION.tar.gz" -C "$INSTALL_DIR" --strip-components=1
rm "/tmp/hadoop-$HADOOP_VERSION.tar.gz"

# Set Hadoop environment variables
echo "export HADOOP_HOME=$INSTALL_DIR" >> "$HOME/.bashrc"
echo 'export PATH=$PATH:$HADOOP_HOME/bin' >> "$HOME/.bashrc"
source "$HOME/.bashrc"

# Configure Hadoop
cp "$HADOOP_HOME/conf/hadoop-env.sh" "$HADOOP_HOME/conf/hadoop-env.sh.backup"
echo "export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk" >> "$HADOOP_HOME/conf/hadoop-env.sh"

# Set up Hadoop data directory (for Namenode and Datanode)
DATA_DIR="/hadoop-data"
sudo mkdir -p "$DATA_DIR"
sudo chown -R $USER:$USER "$DATA_DIR"
echo "export HADOOP_MAPRED_HOME=$HADOOP_HOME" >> "$HADOOP_HOME/conf/hadoop-env.sh"
echo "export HADOOP_COMMON_HOME=$HADOOP_HOME" >> "$HADOOP_HOME/conf/hadoop-env.sh"
echo "export HADOOP_HDFS_HOME=$HADOOP_HOME" >> "$HADOOP_HOME/conf/hadoop-env.sh"
echo "export YARN_HOME=$HADOOP_HOME" >> "$HADOOP_HOME/conf/hadoop-env.sh"
echo "export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native" >> "$HADOOP_HOME/conf/hadoop-env.sh"
echo "export HADOOP_OPTS='-Djava.library.path=$HADOOP_HOME/lib'" >> "$HADOOP_HOME/conf/hadoop-env.sh"
echo "export HADOOP_CONF_DIR=$HADOOP_HOME/conf" >> "$HADOOP_HOME/conf/hadoop-env.sh"

# Format HDFS (only for Namenode)
"$HADOOP_HOME/bin/hadoop" namenode -format

# Print completion message
echo "Java and Hadoop 1.2.1 installation completed successfully!"
