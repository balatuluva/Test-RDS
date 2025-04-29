#output "rds_vpc_security_group_id" {
#  description = "The ID of the RDS VPC Security Group"
#  value       = aws_security_group.RDS-VPC-SG.id
#}
#
#output "rds_ec2_instance_id" {
#  description = "The ID of the RDS EC2 instance"
#  value       = aws_instance.RDS-EC2.id
#}
#
#output "rds_ec2_public_ip" {
#  description = "The public IP of the RDS EC2 instance"
#  value       = aws_instance.RDS-EC2.public_ip
#}