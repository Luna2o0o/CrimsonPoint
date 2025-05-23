provider "aws" {
  region = var.region
}

# --------------------------
# Get Latest Amazon Linux 2 AMI
# --------------------------
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# --------------------------
# S3 Bucket for Sensor Logs
# --------------------------
resource "aws_s3_bucket" "sensor_logs" {
  bucket = var.s3_bucket_name
  force_destroy = true
  tags = {
    Project = "Crimson Point"
  }
}

# --------------------------
# IAM Role for Lambda
# --------------------------
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda-sensor-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_exec" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_s3_full_access" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_sns_publish" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}

# --------------------------
# SNS Topic for Alerts
# --------------------------
resource "aws_sns_topic" "ride_alerts" {
  name = "ride-alerts"
}

# --------------------------
# Lambda Function for IoT Alerts
# --------------------------
resource "aws_lambda_function" "sensor_alert" {
  filename         = "${path.module}/../lambda/sensor_alert.zip"
  function_name    = "sensor-alert-handler"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "sensor_alert.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = filebase64sha256("${path.module}/../lambda/sensor_alert.zip")

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.ride_alerts.arn
    }
  }
}

# --------------------------
# S3 Event Notification Trigger for Lambda
# --------------------------
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.sensor_logs.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.sensor_alert.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".json"
  }

  depends_on = [aws_lambda_permission.allow_s3]
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sensor_alert.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.sensor_logs.arn
}

# --------------------------
# CloudWatch Dashboard
# --------------------------
resource "aws_cloudwatch_dashboard" "crimson_dashboard" {
  dashboard_name = "CrimsonDashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        x    = 0,
        y    = 0,
        width = 24,
        height = 6,
        properties = {
          metrics = [
            [ "AWS/Lambda", "Invocations", "FunctionName", aws_lambda_function.sensor_alert.function_name ],
            [ ".", "Errors", ".", "." ]
          ],
          period = 300,
          stat   = "Sum",
          region = var.region,
          title  = "Sensor Alert Lambda Activity"
        }
      }
    ]
  })
}
