terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_vpc" "task_vpc" {
  cidr_block = var.vpc_cidr_block
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "task_vpc"
  }
}

resource "aws_subnet" "private_subnet_1a" {
  vpc_id = aws_vpc.task_vpc.id
  cidr_block = var.private_subnet_1a_cidr
  availability_zone = "${var.region}a"
  tags = {
    Name = "private_subnet_1a"
  }
}

resource "aws_subnet" "public_subnet_1a" {
  vpc_id     = aws_vpc.task_vpc.id
  cidr_block = var.public_subnet_1a_cidr
  availability_zone = "${var.region}a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet_1a"
  }
}

# Create security group for webapp instance
resource "aws_security_group" "webapp_sg" {
  name        = "webapp_security_group"
  description = "allow ssh inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.task_vpc.id
  tags = {
    Name = "webapp_sg"
  }
}

# Define ingress and egress rules
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.webapp_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.webapp_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.webapp_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


# Create public route table
resource "aws_route_table" "public_RT" {
  vpc_id = aws_vpc.task_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.task_IGW.id
  }
  tags = {
    Name = "public_RT"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "task_IGW" {
  vpc_id = aws_vpc.task_vpc.id
  tags = {
    Name = "task_IGW"
  }
}

# Provide public route table association
resource "aws_route_table_association" "RT_association_1" {
  subnet_id      = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.public_RT.id
}

# Create NAT Gateway
resource "aws_eip" "nat_eip" {
  tags = {
    Name = "nat_eip"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1a.id
  tags = {
    Name = "nat_gw"
  }
}

# Create private route table for private subnet
resource "aws_route_table" "private_RT" {
  vpc_id = aws_vpc.task_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name = "private_RT"
  }
}

# Provide private route table association
resource "aws_route_table_association" "RT_association_3" {
  subnet_id      = aws_subnet.private_subnet_1a.id
  route_table_id = aws_route_table.private_RT.id
}

