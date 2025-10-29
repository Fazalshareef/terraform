data "aws_route_table" "main" {
    filter {
        name = "vpc-id"
        values = [aws_vpc.terraform_vpc.id]

    }
    filter {
        name = "association_main"
        values = ["true"]
    }
}