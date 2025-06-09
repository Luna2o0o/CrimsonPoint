resource "aws_s3_bucket_lifecycle_configuration" "crimson_lifecycle" {
  bucket = aws_s3_bucket.crimson_logs.id

  rule {
    id     = "log-storage-optimization"
    status = "Enabled"

    filter {
      prefix = ""
    }

    transition {
      days          = 30
      storage_class = "GLACIER"
    }

    noncurrent_version_transition {
      days          = 30
      storage_class = "GLACIER"
    }

    expiration {
      expired_object_delete_marker = false
    }
  }
}
