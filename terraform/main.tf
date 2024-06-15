# Configure the provider software version
terraform {
  required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
      }
  }
#Statefile with DynamoDB lock
  backend "s3" {
  bucket = "statefile-bucket-devops-project1"
  key    = "statefile-bucket-devops-project1"
  dynamodb_table = "devops_project1_state_table"
  region = "us-east-1"
  }
}

#Provider
provider "aws" {
  region = "us-east-1"
}

#Network
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "igw" { 
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true" 
}

resource "aws_route_table" "PublicRouteTable" { 
  vpc_id = aws_vpc.main.id
  route { 
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_internet_gateway.igw.id 
  }
}

resource "aws_route_table_association" "PublicRouteTableAssociate" { 
  subnet_id = aws_subnet.subnet.id 
  route_table_id = aws_route_table.PublicRouteTable.id 
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

  ingress { 
     from_port = 30000 
     to_port = 32767
     protocol = "tcp" 
     cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Nodes
resource "aws_instance" "k8s_master" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.subnet.id
  security_groups = [aws_security_group.k8s.id]
  associate_public_ip_address = true

  tags = {
    Name = "K8s-Master"
  }
}

resource "aws_instance" "k8s_worker1" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.subnet.id
  security_groups = [aws_security_group.k8s.id]
  associate_public_ip_address = true

  tags = {
    Name = "K8s-Worker"
  }
}

resource "aws_instance" "k8s_worker2" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.subnet.id
  security_groups = [aws_security_group.k8s.id]
  associate_public_ip_address = true

  tags = {
    Name = "K8s-Worker"
  }
}

#Elastic IPs
resource  "aws_eip" "master-eip"{
    domain = "vpc"
    instance = aws_instance.k8s_master.id
}
resource  "aws_eip" "worker-eip1"{
    domain = "vpc"
    instance = aws_instance.k8s_worker1.id
}

resource  "aws_eip" "worker-eip2"{
    domain = "vpc"
    instance = aws_instance.k8s_worker2.id
}
