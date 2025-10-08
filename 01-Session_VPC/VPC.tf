# ---------------------------
# Create VPC
# ---------------------------
resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "my-vpc"
  }
}

# ---------------------------
# Public Subnets
# ---------------------------
resource "aws_subnet" "public_subnet_1a" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "public_subnet-1a"
  }
}

resource "aws_subnet" "public_subnet_1b" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "public_subnet-1b"
  }
}

# ---------------------------
# Private Subnets
# ---------------------------
/*
resource "aws_subnet" "private_subnet_1a" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private_subnet-1a"
  }
}

resource "aws_subnet" "private_subnet_1b" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private_subnet-1b"
  }
}

*/

# ---------------------------
# Internet Gateway
# ---------------------------
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my_igw"
  }
}

/*

# ---------------------------
# Elastic IP for NAT Gateway
# ---------------------------
resource "aws_eip" "elastic_ip" {
  domain = "vpc"

  tags = {
    Name = "my_elastic_ip"
  }
}

# ---------------------------
# NAT Gateway
# ---------------------------
resource "aws_nat_gateway" "my_natgw" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_subnet_1a.id

  tags = {
    Name = "my_natgw"
  }

  depends_on = [aws_internet_gateway.my_igw]
}

*/

# ---------------------------
# Route Table for Public Subnets
# ---------------------------
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "public_route_table"
  }
}

/*

# ---------------------------
# Route Table for Private Subnets
# ---------------------------
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_natgw.id
  }

  tags = {
    Name = "private_route_table"
  }
}

*/

# ---------------------------
# Route Table Associations
# ---------------------------
resource "aws_route_table_association" "public_1a_association" {
  subnet_id      = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_1b_association" {
  subnet_id      = aws_subnet.public_subnet_1b.id
  route_table_id = aws_route_table.public_route_table.id
}

/*

resource "aws_route_table_association" "private_1a_association" {
  subnet_id      = aws_subnet.private_subnet_1a.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_1b_association" {
  subnet_id      = aws_subnet.private_subnet_1b.id
  route_table_id = aws_route_table.private_route_table.id
}

*/