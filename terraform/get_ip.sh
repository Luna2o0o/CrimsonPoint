#!/bin/bash
# Outputs your public IP in JSON format for Terraform external data source

IP=$(curl -s https://checkip.amazonaws.com)
echo "{\"ip\": \"$IP\"}"
