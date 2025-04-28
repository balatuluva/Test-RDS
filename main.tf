provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "balaterraformbucket"
    key    = "testrds.tfstate"
    region = "us-east-1"
  }
}

resource "aws_vpc" "RDS-VPC" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "RDS-VPC"
  }
}

resource "aws_internet_gateway" "RDS-IGW" {
  vpc_id = aws_vpc.RDS-VPC.id

  tags = {
    Name = "RDS-IGW"
  }
}

resource "aws_subnet" "RDS-VPC-Public-Subnet" {
  count                   = 3
  vpc_id                  = aws_vpc.RDS-VPC.id
  cidr_block              = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"]
  availability_zone       = ["us-east-1a", "us-east-1b", "us-east-1c"]
  map_public_ip_on_launch = true

  tags = {
    Name = "RDS-VPC-Public-Subnet"
  }
}

resource "aws_subnet" "RDS-VPC-Private-Subnet" {
  count                   = 3
  vpc_id                  = aws_vpc.RDS-VPC.id
  cidr_block              = ["192.168.10.0/24", "192.168.20.0/24", "192.168.30.0/24"]
  availability_zone       = ["us-east-1a", "us-east-1b", "us-east-1c"]
  map_public_ip_on_launch = false

  tags = {
    Name = "RDS-VPC-Private-Subnet"
  }
}

resource "aws_route_table" "RDS-VPC-Public-RT" {
  vpc_id = aws_vpc.RDS-VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.RDS-IGW.id
  }

  tags = {
    Name = "RDS-VPC-Public-RT"
  }
}

resource "aws_route_table" "RDS-VPC-Private-RT" {
  vpc_id = aws_vpc.RDS-VPC.id

  tags = {
    Name = "RDS-VPC-Private-RT"
  }
}

resource "aws_route_table_association" "RDS-VPC-Public-RT-Association" {
  count = 3
  subnet_id = aws_subnet.RDS-VPC-Public-Subnet[count.index].id
  route_table_id = aws_route_table.RDS-VPC-Public-RT.id
}

resource "aws_route_table_association" "RDS-VPC-Private-RT-Association" {
  count = 3
  subnet_id = aws_subnet.RDS-VPC-Private-Subnet[count.index].id
  route_table_id = aws_route_table.RDS-VPC-Private-RT.id
}

resource "aws_security_group" "RDS-VPC-SG" {
  name = "RDS-VPC-SG"
  description = "Allow all outbound traffic but only allow ec2 and RDS inbound traffic"
  vpc_id = aws_vpc.RDS-VPC.id

  ingress {
    description = "Allow HTTP"
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow HTTPS"
    protocol = "tcp"
    from_port = 443
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow SSH"
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow MySQL/Aurora from VPC Public Subnets"
    protocol = "tcp"
    from_port = 3306
    to_port = 3306
    cidr_blocks = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"]
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS-VPC-SG"
  }
}