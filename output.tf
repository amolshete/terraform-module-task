output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.task_vpc.id
}

output "private_subnet_1a_id" {
  description = "The ID of the private subnet in availability zone 1a."
  value       = aws_subnet.private_subnet_1a.id
}

output "public_subnet_1a_id" {
  description = "The ID of the public subnet in availability zone 1a."
  value       = aws_subnet.public_subnet_1a.id
}

output "security_group_id" {
  description = "The ID of the webapp security group."
  value       = aws_security_group.webapp_sg.id
}

output "nat_gw_id" {
  description = "The ID of the NAT gateway."
  value       = aws_nat_gateway.nat_gw.id
}

output "private_route_table_id" {
  description = "The ID of the private route table."
  value       = aws_route_table.private_RT.id
}

output "public_route_table_id" {
  description = "The ID of the public route table."
  value       = aws_route_table.public_RT.id
}

output "internet_gateway_id" {
  description = "The ID of the internet gateway."
  value       = aws_internet_gateway.task_IGW.id
}
