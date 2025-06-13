import json
import boto3

sns = boto3.client('sns')
TOPIC_ARN = 'arn:aws:sns:us-east-1:058264110643:ride-alerts'
#change 05826
def lambda_handler(event, context):
    print("Triggered by:", event)

    # Read S3 file details from event
    try:
        record = event['Records'][0]
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']
    except (KeyError, IndexError) as e:
        print(f"❌ Invalid S3 event structure: {e}")
        return { 'status': 'failed', 'error': str(e) }

    # Load JSON from the uploaded file
    s3 = boto3.client('s3')
    try:
        response = s3.get_object(Bucket=bucket, Key=key)
        sensor_data_list = json.loads(response['Body'].read().decode('utf-8'))
    except Exception as e:
        print(f"❌ Failed to load JSON from S3: {e}")
        return { 'status': 'failed', 'error': str(e) }

    # Ensure we're working with a list
    if not isinstance(sensor_data_list, list):
        sensor_data_list = [sensor_data_list]

    alerts_sent = 0
    for alert in sensor_data_list:
        if alert.get('status') == 'critical':
            message = f"🚨 Ride {alert['ride_id']} has a CRITICAL issue!\nDetails: {alert.get('message', 'No additional info.')}"
            print(f"📣 Sending alert: {message}")
            sns.publish(
                TopicArn=TOPIC_ARN,
                Message=message,
                Subject="🚨 Ride Breakdown Alert"
            )
            alerts_sent += 1

    return {
        'status': 'processed',
        'alerts_sent': alerts_sent,
        'records_checked': len(sensor_data_list)
    }
