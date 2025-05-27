#!/bin/bash
terraform -chdir=terraform init
terraform -chdir=terraform apply -auto-approve
