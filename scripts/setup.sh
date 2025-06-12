#!/bin/bash

echo "🔧 Starting setup for Crimson VM..."

# Update System
echo "📦 Updating packages..."
sudo yum update -y

# Install stress tool for CPU load testing
echo "🔥 Installing stress tool..." 
sudo yum install -y stress

# Create a sample log file (optional)
echo "📝 Creating sample log file..." 
mkdir -p /home/ec2-user/logs
echo "System initialized on $(date)" > /home/ec2-user/logs/init.log
chmod +x /home/ec2-user/logs/init.log

# Install Terraform
echo "🚀 Installing Terraform..."
sudo yum install -y yum-utils unzip curl
curl -O https://releases.hashicorp.com/terraform/1.7.5/terraform_1.7.5_linux_amd64.zip
unzip -o terraform_1.7.5_linux_amd64.zip
sudo mv terraform /usr/local/bin/
rm -f terraform_1.7.5_linux_amd64.zip

# Verify Terraform installed
terraform -version

echo "✅ Setup complete!"
