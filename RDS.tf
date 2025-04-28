resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "rds_subnet_group"
  subnet_ids = aws_subnet.RDS-VPC-Private-Subnet[*].id

  tags = {
    Name = "${var.VPC_Name}-SubnetGroup"
  }
}

resource "aws_db_instance" "RDS-MySQL" {
  identifier = "rds"
  instance_class = "db.t3.micro"
  allocated_storage = 5
  engine = "mysql"
  engine_version = "8.0"
  username = "dbadmin"
  password = aws_secretsmanager_secret_version.db_secret_ver.secret_string
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.RDS-VPC-SG.id]
  publicly_accessible = true
  skip_final_snapshot = true
}