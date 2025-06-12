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

# ✅ Add sensor_alert Lambda right below
resource "aws_lambda_function" "sensor_alert" {
  function_name = "sensor_alert"
  handler       = "sensor_alert.lambda_handler"
  runtime       = "python3.12"
  filename      = "${path.module}/../lambda/sensor_alert.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambda/sensor_alert.zip")
  role          = aws_iam_role.lambda_s3_role.arn
}
