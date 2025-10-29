output "vpc_id" {
  value = aws_vpc.terraform_vpc.id
}

output "public_subnet_cidrs" {
  value = aws_subnet.subnets[*].id
}