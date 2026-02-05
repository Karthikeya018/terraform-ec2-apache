terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Security Group in default VPC
resource "aws_security_group" "web_sg" {
  name_prefix = "apache-sg-"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance with Apache installed
resource "aws_instance" "apache" {
  ami           = "ami-0ddda618e961f2270"
  instance_type = "t3.micro"
  key_name      = "mykey"

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
#!/bin/bash
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
echo "<h1>Created using Jenkins Pipeline + Terraform</h1>" > /var/www/html/index.html
EOF

  tags = {
    Name = "Pipeline-Apache"
  }
}
## This is to test the repository from Linu
