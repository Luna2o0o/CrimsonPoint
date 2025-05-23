#!/bin/bash
echo "Installing Git and Terraform..."
sudo yum update -y
sudo yum install -y git unzip

# Install Terraform
curl -O https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip
unzip terraform_1.5.7_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform -version

echo "Cloning Crimson Point repo..."
git clone https://github.com/Luna2o0o/CrimsonPoint.git
cd CrimsonPoint

echo "Zipping Lambda function..."
bash scripts/zip_lambda.sh

echo "Creating DynamoDB table..."
bash scripts/create_table.sh

echo "Uploading schedule item..."
bash scripts/upload_schedule.sh

echo "Applying Terraform..."
cd terraform
terraform init
terraform apply -auto-approve
