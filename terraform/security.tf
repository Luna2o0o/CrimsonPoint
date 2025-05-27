# Run a script to fetch the current public IP
data "external" "my_ip" {
  program = ["bash", "${path.module}/get_ip.sh"]
}

resource "aws_security_group" "crimson_sg" {
  name        = "crimson-sg"
  description = "Allow SSH from my current IP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH access from my machine"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.external.my_ip.result.ip}/32"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "crimson-sg"
  }
}
