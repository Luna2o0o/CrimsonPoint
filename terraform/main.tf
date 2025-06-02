provider "aws" {
  region = var.aws_region
}

# VPC Info
data "aws_vpc" "default" {
  default = true
}

# Latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# EC2 Instance
resource "aws_instance" "crimson_vm" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  key_name                    = var.key_pair_name
  vpc_security_group_ids      = [aws_security_group.crimson_sg.id]
  associate_public_ip_address = true
  user_data                   = file("${path.module}/../scripts/setup.sh")

  tags = {
    Name        = "crimson-vm"
    Environment = var.environment
  }

  depends_on = [aws_security_group.crimson_sg]
}

# S3 Bucket for Logs
resource "aws_s3_bucket" "crimson_logs" {
  bucket = var.log_bucket_name

  tags = {
    Name        = "Crimson Point Logs"
    Environment = var.environment
  }
}

# Server-side encryption for S3
resource "aws_s3_bucket_server_side_encryption_configuration" "crimson_encryption" {
  bucket = aws_s3_bucket.crimson_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
