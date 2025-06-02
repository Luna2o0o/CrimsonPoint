# AWS Region
variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

# EC2 Instance Type
variable "instance_type" {
  description = "EC2 instance type for the Crimson Point server"
  type        = string
  default     = "t2.micro"
}

# EC2 Key Pair Name
variable "key_pair_name" {
  description = "Name of the EC2 key pair"
  type        = string
  default     = "CrimsonKey"  # Make sure this key is uploaded to AWS
}

# S3 Bucket Name
variable "log_bucket_name" {
  description = "Name of the S3 bucket used for performance logs"
  type        = string
  default     = "crimson-point-logs2025"
}

# Tags
variable "environment" {
  description = "Environment tag (e.g., Production, Dev)"
  type        = string
  default     = "Production"
}
