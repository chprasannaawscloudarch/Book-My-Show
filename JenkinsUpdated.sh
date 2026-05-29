#!/bin/bash

set -euo pipefail

echo "================================================="
echo "Jenkins Fresh Installation Script"
echo "================================================="

# Cleanup old Jenkins installation
echo "Cleaning old Jenkins installation..."

sudo systemctl stop jenkins 2>/dev/null || true
sudo systemctl disable jenkins 2>/dev/null || true

sudo apt-get purge -y jenkins || true
sudo apt-get autoremove -y
sudo apt-get autoclean

sudo rm -f /etc/apt/sources.list.d/jenkins.list
sudo rm -f /etc/apt/keyrings/jenkins-keyring.asc
sudo rm -rf /var/lib/jenkins
sudo rm -rf /var/log/jenkins

echo "================================================="
echo "Ubuntu Information"
echo "================================================="
cat /etc/os-release

echo "================================================="
echo "Installing Prerequisites"
echo "================================================="

sudo apt-get update
sudo apt-get install -y \
    curl \
    wget \
    gnupg \
    ca-certificates \
    lsb-release \
    software-properties-common \
    apt-transport-https

echo "================================================="
echo "Installing Java 21"
echo "================================================="

sudo apt install -y fontconfig openjdk-21-jdk

java -version

echo "================================================="
echo "Configuring Jenkins Repository"
echo "================================================="

sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key | \
sudo tee /etc/apt/keyrings/jenkins-keyring.asc > /dev/null

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
| sudo tee /etc/apt/sources.list.d/jenkins.list

echo "================================================="
echo "Repository Validation"
echo "================================================="

echo "Testing Jenkins Repository..."

curl -I https://pkg.jenkins.io/debian-stable/ || true

echo "================================================="
echo "Updating Package Metadata"
echo "================================================="

sudo apt-get update

echo "================================================="
echo "Checking Jenkins Package Availability"
echo "================================================="

apt-cache policy jenkins

echo "================================================="
echo "Installing Jenkins"
echo "================================================="

sudo apt install -y jenkins

echo "================================================="
echo "Starting Jenkins"
echo "================================================="

sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl restart jenkins

sleep 15

echo "================================================="
echo "Jenkins Status"
echo "================================================="

sudo systemctl status jenkins
echo "================================================="
echo "Installation Completed"
echo "================================================="
