#!/bin/bash
sudo yum update -y
sudo yum install -y yum-utils unzip curl
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum install -y terraform
terraform -version
