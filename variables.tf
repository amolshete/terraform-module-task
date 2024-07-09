variable "region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.10.0.0/16"
}

variable "private_subnet_1a_cidr" {
  description = "The CIDR block for the private subnet in availability zone 1a."
  type        = string
  default     = "10.10.1.0/24"
}

variable "public_subnet_1a_cidr" {
  description = "The CIDR block for the public subnet in availability zone 1a."
  type        = string
  default     = "10.10.0.0/24"
}
