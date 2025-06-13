import json
import boto3

sns = boto3.client('sns')
TOPIC_ARN = 'arn:aws:sns:us-east-1:<your-account-id>:ride-alerts'

def lambda_handler(event, context):
    print("Triggered by:", event)

    # Read from S3
    record = event['Records'][0]
    bucket = record['s3']['bucket']['name']
    key = record['s3']['object']['key']

    s3 = boto3.client('s3')
    response = s3.get_object(Bucket=bucket, Key=key)
    sensor_data_list = json.loads(response['Body'].read().decode('utf-8'))

    # Handle a list of alerts
    for alert in sensor_data_list:
        if alert.get('status') == 'critical':
            message = f"Ride {alert['ride_id']} has a CRITICAL issue!\nDetails: {alert.get('message', 'No message')}"
            print(f"📣 Sending alert: {message}")
            sns.publish(TopicArn=TOPIC_ARN, Message=message, Subject="🚨 Ride Breakdown Alert")

    return { 'status': 'Processed', 'alerts_checked': len(sensor_data_list) }
