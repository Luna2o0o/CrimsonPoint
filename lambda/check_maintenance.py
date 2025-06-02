import boto3
from datetime import datetime

# Initialize DynamoDB resource
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('equipment_usage')

def lambda_handler(event, context):
    print("🔍 Checking equipment maintenance thresholds...")
    
    try:
        response = table.scan()
        for item in response.get('Items', []):
            component_id = item.get('component_id')
            usage = int(item.get('usage_count', 0))
            threshold = int(item.get('max_threshold', 100))

            if usage >= threshold:
                print(f"⚠️ Maintenance needed for: {component_id} (Usage: {usage}, Threshold: {threshold})")
            else:
                print(f"✅ {component_id} is OK (Usage: {usage})")

        return {
            'statusCode': 200,
            'body': 'Maintenance check completed.'
        }

    except Exception as e:
        print(f"❌ Error occurred: {str(e)}")
        raise
