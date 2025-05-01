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
# output "security_group_id" {
#   description = "The ID of the created security group"
#   value       = aws_security_group.main.id
# }
# output "subnet_ids" {
#   description = "List of created subnet IDs"
#   value       = [ for subnet in aws_subnet.subnets : subnet.id ]
# }
# output "subnet_details" {
#   description = "Details of created subnets"
#   value = { for name, subnet in aws_subnet.subnets : name => {
#     id = subnet.id
#     cidr_block        = subnet.cidr_block
#     availability_zone = subnet.availability_zone
#     }
#   }
# }