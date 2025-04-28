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

