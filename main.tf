provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "balaterraformbucket"
    key    = "testrds.tfstate"
    region = "us-east-1"
  }
}

resource "aws_vpc" "RDS-VPC" {
  cidr_block           = var.VPC_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.VPC_Name
  }
}

resource "aws_internet_gateway" "RDS-IGW" {
  vpc_id = aws_vpc.RDS-VPC.id

  tags = {
    Name = "${var.VPC_Name}-IGW"
  }
}

resource "aws_subnet" "RDS-VPC-Public-Subnet" {
  count                   = length(var.RDS_VPC_Public_Subnet)
  vpc_id                  = aws_vpc.RDS-VPC.id
  cidr_block              = element(var.RDS_VPC_Public_Subnet, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.VPC_Name}-Public-Subnet-${count.index+1}"
  }
}

resource "aws_subnet" "RDS-VPC-Private-Subnet" {
  count                   = length(var.RDS_VPC_Private_Subnet)
  vpc_id                  = aws_vpc.RDS-VPC.id
  cidr_block              = element(var.RDS_VPC_Private_Subnet, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.VPC_Name}-Private-Subnet-${count.index+1}"
  }
}

resource "aws_route_table" "RDS-VPC-Public-RT" {
  vpc_id = aws_vpc.RDS-VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.RDS-IGW.id
  }

  tags = {
    Name = "${var.VPC_Name}-Public-RT"
  }
}

resource "aws_route_table" "RDS-VPC-Private-RT" {
  vpc_id = aws_vpc.RDS-VPC.id

  tags = {
    Name = "${var.VPC_Name}-Private-RT"
  }
}

resource "aws_route_table_association" "RDS-VPC-Public-RT-Association" {
  count = length(var.RDS_VPC_Public_Subnet)
  subnet_id = element(aws_subnet.RDS-VPC-Public-Subnet.*.id, count.index)
  route_table_id = aws_route_table.RDS-VPC-Public-RT.id
}

resource "aws_route_table_association" "RDS-VPC-Private-RT-Association" {
  count = length(var.RDS_VPC_Private_Subnet)
  subnet_id = element(aws_subnet.RDS-VPC-Private-Subnet.*.id, count.index)
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