#!/bin/bash

# Update and upgrade system packages
sudo apt-get update -y
sudo apt-get upgrade -y

# Initialization message
echo "Starting Git setup..."
# Install Git
sudo apt-get install -y git
# success message
echo "Git setup is complete!"

# Initialization message
echo "Starting Docker setup..."
# Install Docker
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update -y
sudo apt-get install -y docker-ce
# Add vagrant user to docker group
sudo usermod -aG docker vagrant
# success message
echo "Docker setup is complete!"

# Starting Java 17 setup
echo "Starting Java 17 setup..."

# Java installation
sudo apt update
sudo apt install -y fontconfig openjdk-17-jre  # Add -y to avoid user prompt

# Verify Java installation
java -version
if [ $? -eq 0 ]; then
  echo "Java 17 setup is complete!"
else
  echo "Java installation failed. Exiting."
  exit 1
fi

# Starting Jenkins setup
echo "Starting Jenkins setup..."

# Add Jenkins repository key
sudo apt update
sudo apt install -y wget  # Ensure wget is installed before using it

sudo wget -q -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

# Add Jenkins repository
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package list and install Jenkins
sudo apt-get update
sudo apt-get install -y jenkins  # Added -y to avoid prompt

# Start Jenkins and enable it to run at startup
sudo usermod -aG docker jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo systemctl restart docker

# Check if Jenkins started successfully
if systemctl is-active --quiet jenkins; then
  echo "Jenkins setup is complete!"
  echo "You can access Jenkins"
else
  echo "Jenkins installation failed. Check the system logs for errors."
  exit 1
fi

# Initialization message
echo "Starting Minikube setup..."
# Install Minikube dependencies
sudo apt-get install -y conntrack
# Download and install Minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube /usr/local/bin/
# Install Kubectl
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
# Clean up
rm minikube
# success message
echo "MiniKube setup is complete!"

echo "Setup complete! Git, Docker, Java 17, Jenkins and Minikube have been installed."
