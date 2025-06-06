# IAM role for Lambda (shared role)
resource "aws_iam_role" "lambda_s3_role" {
  name = "lambda-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM policy to allow Lambda access to S3 logs and CloudWatch Logs
resource "aws_iam_policy" "lambda_s3_policy" {
  name = "lambda-s3-access"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::${var.log_bucket_name}",
          "arn:aws:s3:::${var.log_bucket_name}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

# IAM policy to allow Lambda to scan DynamoDB
resource "aws_iam_policy" "lambda_dynamodb_policy" {
  name = "lambda-dynamodb-scan"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:Scan",
          "dynamodb:GetItem"
        ],
        Resource = "arn:aws:dynamodb:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/equipment_usage"
      }
    ]
  })
}

# Attach both policies to the Lambda role
resource "aws_iam_role_policy_attachment" "attach_lambda_s3_policy" {
  role       = aws_iam_role.lambda_s3_role.name
  policy_arn = aws_iam_policy.lambda_s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_lambda_dynamodb_policy" {
  role       = aws_iam_role.lambda_s3_role.name
  policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
}

# This data block is needed for the account_id interpolation
data "aws_caller_identity" "current" {}
