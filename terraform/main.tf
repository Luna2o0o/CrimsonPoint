provider "aws" {
  region = "us-east-1"
}

# Use latest Amazon Linux 2 AMI dynamically
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "crimson_vm" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"
  key_name                    = "CrimsonKey"
  vpc_security_group_ids      = [aws_security_group.crimson_sg.id]
  associate_public_ip_address = true

  user_data = file("${path.module}/../scripts/setup.sh")

  tags = {
    Name = "crimson-vm"
  }
}

resource "aws_s3_bucket" "crimson_logs" {
  bucket = "crimson-point-logs"

  tags = {
    Name        = "Crimson Point Log Storage"
    Environment = "Production"
  }
}
