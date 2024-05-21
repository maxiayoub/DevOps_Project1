# Configure the provider software version
terraform {
  required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
      }
  }
}
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_security_group" "k8s" {
  vpc_id = aws_vpc.main.id

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

resource "aws_instance" "k8s_master" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.subnet.id
  security_groups = [aws_security_group.k8s.name]
  associate_public_ip_address = true

  tags = {
    Name = "K8s-Master"
  }
}

resource "aws_instance" "k8s_worker" {
  #count         = 2
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.subnet.id
  security_groups = [aws_security_group.k8s.name]
  associate_public_ip_address = true

  tags = {
    Name = "K8s-Worker"
    #Name = "K8s-Worker-${count.index}"
  }
}
