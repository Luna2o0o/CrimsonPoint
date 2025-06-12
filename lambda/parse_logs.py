import json
import boto3
import os

def lambda_handler(event, context):
    s3 = boto3.client('s3')

    try:
        records = event.get("Records", [])
        if not records:
            raise ValueError("No Records found in the event.")

        bucket = records[0]['s3']['bucket']['name']
        key    = records[0]['s3']['object']['key']

        # Filter out unwanted files (optional)
        if not key.endswith(".csv"):
            print(f"Skipping unsupported file type: {key}")
            return {
                'statusCode': 200,
                'body': json.dumps(f'Skipped unsupported file type: {key}')
            }

        # Get object from S3
        response = s3.get_object(Bucket=bucket, Key=key)
        content = response['Body'].read().decode('utf-8')

        print(f"📦 Log File: {key}")
        print("📝 Contents:")
        print(content)

        # Optional: Add logic to parse downtime, alert if needed
        return {
            'statusCode': 200,
            'body': json.dumps('Log parsed successfully.')
        }

    except Exception as e:
        print(f"❌ Error: {e}")
        raise e
