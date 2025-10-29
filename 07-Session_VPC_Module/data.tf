data "aws_route_table" "main" {
    depends_on = [aws_vpc.terraform_vpc]
  filter {
    name   = "vpc-id"
    values = [aws_vpc.terraform_vpc.id]

  }
  filter {
    name   = "association.main"
    values = ["true"]
  }
}