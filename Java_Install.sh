#!/bin/bash

# Function to check if the command was successful
check_command() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# Set the desired Java version (Update this if needed)
java_version="8"

# Install Java
echo "Installing Java..."
sudo apt update
sudo apt install -y openjdk-${java_version}-jdk
check_command "Java installation failed."

# Set JAVA_HOME and update PATH
echo "Configuring environment variables..."
JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
export JAVA_HOME
echo "export JAVA_HOME=${JAVA_HOME}" >> ~/.bashrc

PATH=$PATH:$JAVA_HOME/bin
echo "export PATH=\$PATH:${JAVA_HOME}/bin" >> ~/.bashrc

source ~/.bashrc

# Check Java version
echo "Java installation complete. Checking version..."
java -version
