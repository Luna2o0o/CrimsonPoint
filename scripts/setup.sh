#!/bin/bash

echo "Starting setup for Crimson VM..."

# Update System
echo "Updating packages..."
sudo yum update -y

# Install stress tool for CPU load testing
echo "Installing stress tool..." 
sudo yum install -y stress

# Create a sample log file (optional)
echo "Creating sample log file..." 
mkdir -p /home/ec2-user/logs
echo "System initialized on $(date)" > /home/ec2-user/logs/init.log
chmod +x /home/ec2-user/logs/init.log

# Install Terraform
set -e  # Stop the script if any command fails 
echo "Starting Terraform installation..."
 
# Change to home directory
cd ~ 

# Download Terraform binary (version 1.7.5 — update if needed)
echo "Downloading Terraform..."
curl -O https://releases.hashicorp.com/terraform/1.7.5/terraform_1.7.5_linux_amd64.zip
 
# Install unzip if missing
if ! command -v unzip &> /dev/null; then
  echo "Installing unzip..."
  sudo yum install -y unzip
fi
 
# Unzip the Terraform binary
echo "Unzipping Terraform..."
unzip -o terraform_1.7.5_linux_amd64.zip
 
# Move it to a global path
echo "Moving Terraform binary to /usr/local/bin..."
sudo mv terraform /usr/local/bin/

# Verify the installation
echo "Checking Terraform version..."
terraform -version
echo "🎉 Terraform installation complete!"
 
