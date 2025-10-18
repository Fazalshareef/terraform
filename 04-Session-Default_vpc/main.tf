terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  # region can be overridden via CLI / env or change default here
  region = var.aws_region
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
  description = "AWS region to create the VPC in"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
  description = "CIDR for the VPC"
}

# Discover available AZs in the selected region
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = data.aws_availability_zones.available.names
  # number of AZs we will create subnets for
  az_count = length(local.azs)
}

# VPC
resource "aws_vpc" "default_like" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "default-vpc-like"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.default_like.id

  tags = {
    Name = "default-vpc-like-igw"
  }
}

# Route Table (main for this VPC)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default_like.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "default-vpc-like-rt"
  }
}

# Subnets: 1 per AZ. Use cidrsubnet to carve /24s from the /16 (16 + 8 = /24).
# We map indexes to AZ names so we can generate stable subnet CIDRs.
resource "aws_subnet" "az_subnets" {
  for_each = { for idx, az in local.azs : tostring(idx) => az }

  vpc_id            = aws_vpc.default_like.id
  availability_zone = each.value

  # create /24 subnets: subnet number = index
  cidr_block = cidrsubnet(var.vpc_cidr, 8, tonumber(each.key))

  map_public_ip_on_launch = true

  tags = {
    Name = "default-vpc-like-subnet-${each.value}"
  }
}

# Associate the route table with each subnet
resource "aws_route_table_association" "subnet_assoc" {
  for_each = aws_subnet.az_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Security Group similar to default SG behavior:
# - Allow inbound from same security group on all ports
# - Allow all outbound
resource "aws_security_group" "default_like_sg" {
  name   = "default-like-sg"
  vpc_id = aws_vpc.default_like.id
  description = "Default-like security group: inbound from self, all outbound allowed"

  # Ingress: allow all protocols/ports from same SG (self)
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    self            = true
    description     = "Allow all inbound from same security group"
  }

  # Egress: allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "default-like-sg"
  }
}

output "vpc_id" {
  value = aws_vpc.default_like.id
}

output "subnet_ids" {
  value = [for s in aws_subnet.az_subnets : s.id]
}

output "public_subnet_cidrs" {
  value = [for s in aws_subnet.az_subnets : s.cidr_block]
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}

output "route_table_id" {
  value = aws_route_table.public.id
}

output "default_like_security_group_id" {
  value = aws_security_group.default_like_sg.id
}
