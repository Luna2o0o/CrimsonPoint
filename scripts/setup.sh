#!/bin/bash

echo "🔧 Starting setup for Crimson VM..."

# Update system
echo "📦 Updating packages..."
sudo yum update -y

# Install Python 3 and pip
echo "🐍 Installing Python 3 and pip..."
sudo yum install -y python3
sudo pip3 install --upgrade pip

# Install AWS CLI v2
echo "☁️ Installing AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws

# Install stress tool for CPU load testing
echo "🔥 Installing stress tool..."
sudo yum install -y stress

# Create a sample log file (optional)
echo "📝 Creating sample log file..."
mkdir -p /home/ec2-user/logs
echo "System initialized on $(date)" > /home/ec2-user/logs/init.log

# Ensure correct permissions
chmod +x /home/ec2-user/logs/init.log

echo "✅ Setup complete!"
