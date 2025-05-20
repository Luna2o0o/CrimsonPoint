provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["137112412989"] # Amazon Linux AMIs

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "oasis_vm" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  key_name      = "OasisKey"

  user_data = file("${path.module}/../scripts/setup.sh")

  tags = {
    Name = "oasis-tf-vm"
  }
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "oasis-logs-luna"
  force_destroy = true
  tags = {
    Environment = "Dev"
    Project     = "Outlaw Oasis"
  }
}
