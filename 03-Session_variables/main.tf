#VPC 1 CREATION 

resource "aws_vpc" "vpc_01" {
  cidr_block           = var.vpc_01_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Project_Name = var.project_name
    Environment  = var.environment

  }
}

# VPC 2 CREATION 

resource "aws_vpc" "vpc_02" {
  cidr_block           = var.vpc_02_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = var.project_name
    Environment = var.environment

  }
}

# SUBNET for VPC 1 CREATION

# PUBLIC SUBNET

resource "aws_subnet" "public_subnet_01" {
  vpc_id            = aws_vpc.vpc_01.id
  availability_zone = var.us_east_1a_zone
  cidr_block        = "10.0.1.0/24"

  tags = {
    Name        = "${var.project_name}-public_subnet_01"
    Environment = var.environment
  }
}

# PRIVATE SUBNET 

resource "aws_subnet" "private_subnet_01" {
  vpc_id            = aws_vpc.vpc_01.id
  availability_zone = var.us_east_1b_zone
  cidr_block        = "10.0.2.0/24"

  tags = {
    Name        = "${var.project_name}-private_subnet_01"
    Environment = var.environment
  }
}


# SUBNET for VPC 2 CREATION

# PUBLIC SUBNET

resource "aws_subnet" "public_subnet_02" {
  vpc_id            = aws_vpc.vpc_02.id
  availability_zone = var.us_east_1a_zone
  cidr_block        = "198.16.0.0/24"

  tags = {
    Name        = "${var.project_name}-pubilc_subnet_02"
    Environment = var.environment
  }
}

# PRIAVTE SUBNET

resource "aws_subnet" "private_subnet_02" {
  vpc_id            = aws_vpc.vpc_02.id
  availability_zone = var.us_east_1b_zone
  cidr_block        = "198.16.1.0/24"

  tags = {
    Name = "${var.project_name}-private_subnet_02"
  }
}



# INTERNET GATEWAY

resource "aws_internet_gateway" "igw_01" {
  vpc_id = aws_vpc.vpc_01.id

  tags = {
    Name        = "${var.project_name}-IGW_01"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "igw_02" {
  vpc_id = aws_vpc.vpc_02.id

  tags = {
    Name        = "${var.project_name}-IGW_02"
    Environment = var.environment
  }
}


# FETCHING DEFAULT ROUTE TABLES 

data "aws_route_table" "RT_main_01" {
  filter {
    name  = "vpc-id"
    values = [aws_vpc.vpc_01.id]
  }

  filter {
    name   = "association.main"
    values = ["true"]

  }
}

data "aws_route_table" "RT_main_02" {
  filter {
    name  = "vpc-id"
    values = [aws_vpc.vpc_02.id]
  }

  filter {
    name  = "association.main"
    values = ["true"]
  }
}

# CREATING THE ROUTE TABLES

resource "aws_route_table" "private_rt_01" {
  vpc_id = aws_vpc.vpc_01.id

  tags = {
    Name        = var.project_name
    Environment = var.environment
  }
}


resource "aws_route_table" "private_rt_02" {
  vpc_id = aws_vpc.vpc_02.id

  tags = {
    Name = var.project_name
    Env  = var.environment
  }
}


# ASSIGNING ROUTE TABLES WITH VPC 1 SUBNETS 

resource "aws_route_table_association" "rt_01_to_public_01" {
  subnet_id      = aws_subnet.public_subnet_01.id
  route_table_id = data.aws_route_table.RT_main_01.id
}

resource "aws_route_table_association" "rt_01_to_private_01" {
  subnet_id      = aws_subnet.private_subnet_01.id
  route_table_id = aws_route_table.private_rt_01.id
}

# ASSIGNING ROUTE TABLES WITH VPC 2 SUBNETS 

resource "aws_route_table_association" "rt_02_to_public_02" {
  subnet_id      = aws_subnet.public_subnet_02.id
  route_table_id = data.aws_route_table.RT_main_02.id
}

resource "aws_route_table_association" "rt_02_to_private_02" {
  subnet_id      = aws_subnet.private_subnet_02.id
  route_table_id = aws_route_table.private_rt_02.id
}




# CREATING VPC PEERING

resource "aws_vpc_peering_connection" "vpc_peering_01" {
  vpc_id      = aws_vpc.vpc_01.id
  peer_vpc_id = aws_vpc.vpc_02.id
  auto_accept = true

  tags = {
    Name         = "vpc_01 to vpc_02 peering"
    Project_name = var.project_name
    Environment  = var.environment
  }

}




# CREATING ROUTES FOR VPC 1 SUBNETS 

resource "aws_route" "public_vpc_01_route" {
  route_table_id         = data.aws_route_table.RT_main_01.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_01.id

}

resource "aws_route" "public_vpc_01_peer_route" {
  route_table_id         = data.aws_route_table.RT_main_01.id
  destination_cidr_block = var.vpc_02_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering_01.id
}


# CREATING ROUTES FOR VPC 2 SUBNETS 

resource "aws_route" "public_vpc_02_route" {
  route_table_id         = data.aws_route_table.RT_main_02.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_02.id
}

resource "aws_route" "public_vpc_02_peer_route" {
  route_table_id         = data.aws_route_table.RT_main_02.id
  destination_cidr_block = var.vpc_01_cidr
  vpc_peering_connection_id   = aws_vpc_peering_connection.vpc_peering_01.id
}







