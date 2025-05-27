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

resource "aws_s3_bucket_notification" "bucket_notify" {
  bucket = aws_s3_bucket.crimson_logs.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.log_parser.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".txt"
  }

  depends_on = [aws_lambda_permission.allow_s3]
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.log_parser.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.crimson_logs.arn
}
