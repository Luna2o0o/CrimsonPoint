#!/bin/bash
echo "📦 Zipping Lambda functions..."

# Navigate to the lambda directory
cd $(dirname "$0")/../lambda

# Zip parse_logs.py
if [ -f "parse_logs.py" ]; then
  zip -o parse_logs.zip parse_logs.py
  echo "✅ parse_logs.zip created!"
else
  echo "❌ parse_logs.py not found!"
fi

# Zip check_maintenance.py
if [ -f "check_maintenance.py" ]; then
  zip -o check_maintenance.zip check_maintenance.py
  echo "✅ check_maintenance.zip created!"
else
  echo "❌ check_maintenance.py not found!"
fi
