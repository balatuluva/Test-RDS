resource "aws_instance" "RDS-EC2" {
  ami = "ami-0f9de6e2d2f067fca"
  availability_zone = var.azs[0]
  instance_type = "t2.micro"
  key_name = var.key_name
  subnet_id = aws_subnet.RDS-VPC-Public-Subnet[0].id
  vpc_security_group_ids = ["${aws_security_group.RDS-VPC-SG.id}"]
  associate_public_ip_address = true
  iam_instance_profile = "Delete-Later"
  depends_on = [aws_security_group.RDS-VPC-SG]

  tags = {
    Name = "RDS-EC2"
  }
}