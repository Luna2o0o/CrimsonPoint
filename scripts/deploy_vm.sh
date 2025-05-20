#!/bin/bash
REGION="us-east-1"

AMI_ID=$(aws ec2 describe-images \
    --owners "137112412989" \
    --filters "Name=name,Values=amzn2-ami-hvm-*-x86_64-gp2" \
              "Name=state,Values=available" \
    --query "Images[*].[ImageId,CreationDate]" \
    --region $REGION --output text | sort -k2 -r | head -n1 | cut -f1)

aws ec2 run-instances \
    --image-id $AMI_ID \
    --instance-type t2.micro \
    --key-name OasisKey \
    --security-groups default \
    --user-data file://scripts/setup.sh \
    --region $REGION \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=oasis-bash-vm}]'

aws s3 mb s3://outlaw-logs-luna
aws s3 cp logs/outlaw_log1.txt s3://outlaw-logs-luna/
