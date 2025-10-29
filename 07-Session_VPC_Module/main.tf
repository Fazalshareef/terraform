resource "aws_vpc" "terraform_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    name = var.vpc_name_tag
  }

}

resource "aws_subnet" "subnets" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "${var.vpc_name_tag}-public-${count.index + 1}"

  }

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "my_igw"
  }
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.terraform_vpc.id

    tags = {
        Name = $(var.vpc_name_tag)-public_rt
    }
}


resource "aws_route_table_association" "routing" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route" "route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}



