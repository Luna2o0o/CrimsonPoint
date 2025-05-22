#!/bin/bash
aws dynamodb put-item \
  --table-name outlaw-schedule \
  --item file://../data/schedule.json \
  --return-consumed-capacity TOTAL
