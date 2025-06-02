resource "aws_glue_catalog_database" "crimson_logs" {
  name = "crimson_logs_db"
}

resource "aws_glue_crawler" "crimson_log_crawler" {
  name          = "crimson-log-crawler"
  role          = aws_iam_role.glue_crawler_role.arn
  database_name = aws_glue_catalog_database.crimson_logs.name

  s3_target {
    path = "s3://${var.log_bucket_name}/"
  }

  schema_change_policy {
    update_behavior = "UPDATE_IN_DATABASE"
    delete_behavior = "DEPRECATE_IN_DATABASE"
  }
}
