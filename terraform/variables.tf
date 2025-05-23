variable "region" {
  description = "AWS region to deploy resources in"
  default     = "us-east-1"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket to store sensor logs"
  default     = "crimson-sensor-logs"
}
