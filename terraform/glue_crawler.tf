## 2. Terraform: glue_crawler.tf
# Automates creation of an AWS Glue Crawler for S3 logs

resource "aws_glue_catalog_database" "crimson_logs" {
  name = "crimson_logs_db"
}

resource "aws_glue_crawler" "crimson_log_crawler" {
  name         = "crimson-log-crawler"
  role         = aws_iam_role.glue_crawler_role.arn
  database_name = aws_glue_catalog_database.crimson_logs.name
  s3_target {
    path = "s3://crimson-point-logs/"
  }
  schedule = "cron(0 * * * ? *)" # every hour (optional)
  schema_change_policy {
    update_behavior = "UPDATE_IN_DATABASE"
    delete_behavior = "DEPRECATE_IN_DATABASE"
  }
}
