#!/bin/bash

sudo apt-get update
sudo apt-get -y upgrade

#install java
sudo apt-get install -y default-jdk

# install jenkins
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install -y jenkins && echo "Jenkins was installed! Login to http://127.0.0.1:8080"
# $(sudo cat sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
