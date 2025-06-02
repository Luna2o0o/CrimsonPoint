resource "aws_lambda_function" "check_maintenance" {
  function_name = "check_maintenance"
  handler       = "check_maintenance.lambda_handler"
  runtime       = "python3.12"
  role          = aws_iam_role.lambda_s3_role.arn

  filename         = "${path.module}/../lambda/check_maintenance.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambda/check_maintenance.zip")
}

resource "aws_cloudwatch_event_rule" "daily_maintenance" {
  name                = "run-check-maintenance"
  schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.daily_maintenance.name
  target_id = "check-maintenance"
  arn       = aws_lambda_function.check_maintenance.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.check_maintenance.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_maintenance.arn
}
