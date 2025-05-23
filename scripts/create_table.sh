#!/bin/bash

aws dynamodb create-table \
  --table-name crimsion-schedule \
  --attribute-definitions AttributeName=task_id,AttributeType=S \
  --key-schema AttributeName=task_id,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
