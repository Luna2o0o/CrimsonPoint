import json
import boto3
import os

def lambda_handler(event, context):
    s3 = boto3.client('s3')

    # Get bucket and object key from the event
    bucket = event['Records'][0]['s3']['bucket']['name']
    key    = event['Records'][0]['s3']['object']['key']

    try:
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
        print(e)
        raise e
`
