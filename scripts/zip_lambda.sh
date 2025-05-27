#!/bin/bash
echo "📦 Zipping Lambda function..."
cd $(dirname $0)/../lambda
zip -o parse_logs.zip parse_logs.py
echo "✅ parse_logs.zip created!"
