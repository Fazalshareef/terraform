output "VPC1_id" {
  description = "ID of Vpc 01"
  value       = aws_vpc.vpc_01.id
}

output "VPC2_id" {
  description = "ID of VPC 02"
  value       = aws_vpc.vpc_02.id

}


output "vpc_peering_id" {
  description = "Peering Connection ID"
  value       = aws_vpc_peering_connection.vpc_peering_01.id
}