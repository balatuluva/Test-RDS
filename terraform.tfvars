aws_region = "us-east-1"
VPC_cidr_block = "192.168.0.0/16"
VPC_Name = "RDS-VPC"
RDS_VPC_Public_Subnet = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"]
azs = ["us-east-1a", "us-east-1b", "us-east-1c"]
RDS_VPC_Private_Subnet = ["192.168.10.0/24", "192.168.20.0/24", "192.168.30.0/24"]
key_name = "DevOps-Key"