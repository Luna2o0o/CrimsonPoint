resource "aws_lambda_function" "log_parser" {
  function_name = "parse_logs"
  role          = aws_iam_role.lambda_s3_role.arn
  handler       = "parse_logs.lambda_handler"
  runtime       = "python3.12"

  filename         = "${path.module}/../lambda/parse_logs.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambda/parse_logs.zip")

  timeout = 10

  environment {
    variables = {
      LOG_BUCKET = aws_s3_bucket.crimson_logs.bucket
    }
  }

  depends_on = [aws_iam_role.lambda_s3_role]
}

# ✅ Add sensor_alert Lambda
resource "aws_lambda_function" "sensor_alert" {
  function_name = "sensor_alert"
  handler       = "sensor_alert.lambda_handler"
  runtime       = "python3.12"
  filename      = "${path.module}/../lambda/sensor_alert.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambda/sensor_alert.zip")
  role          = aws_iam_role.lambda_s3_role.arn
}

# ✅ Allow S3 to invoke sensor_alert Lambda
resource "aws_lambda_permission" "allow_s3_sensor_alert" {
  statement_id  = "AllowS3InvokeSensorAlert"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sensor_alert.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.crimson_logs.arn
}

# ✅ Attach S3 trigger to sensor_alert Lambda
resource "aws_s3_bucket_notification" "sensor_alert_trigger" {
  bucket = aws_s3_bucket.crimson_logs.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.sensor_alert.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".json"  # Only trigger on .json uploads
  }

  depends_on = [aws_lambda_permission.allow_s3_sensor_alert]
}
