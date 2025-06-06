provider "aws" {
  region = var.aws_region
}

# VPC Info
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
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

# Launch Template
resource "aws_launch_template" "crimson_template" {
  name_prefix   = "crimson-launch-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.crimson_sg.id]

  user_data = base64encode(file("${path.module}/../scripts/setup.sh"))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "crimson-vm"
      Environment = var.environment
    }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "crimson_asg" {
  name                      = "crimson-asg"
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 1
  vpc_zone_identifier       = data.aws_subnets.default.ids
  health_check_type         = "EC2"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.crimson_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "crimson-auto-instance"
    propagate_at_launch = true
  }
}

# Target Tracking Scaling Policy
resource "aws_autoscaling_policy" "cpu_tracking" {
  name                   = "cpu-scaling-policy"
  autoscaling_group_name = aws_autoscaling_group.crimson_asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0
  }
}

# S3 Bucket for Logs
resource "aws_s3_bucket" "crimson_logs" {
  bucket = var.log_bucket_name

  tags = {
    Name        = "Crimson Point Logs"
    Environment = var.environment
  }
}

# S3 Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "crimson_encryption" {
  bucket = aws_s3_bucket.crimson_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
