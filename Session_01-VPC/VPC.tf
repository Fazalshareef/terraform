#Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "my-vpc"
  }
}

#Create Public Subnet 1a
resource "aws_subnet" "public_subnet_1a" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "public_subnet-1a"
  }
}
#Create Priavte Subnet 1a

resource "aws_subnet" "priavte_subnet_1a" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private_subnet-1a"
  }
}

#Create Public Subnet 1b


resource "aws_subnet" "public_subnet_1b" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "public_subnet-1b"
  }
}

#Create Priavte Subnet 1b

resource "aws_subnet" "priavte_subnet_1b" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "priavte_subnet-1b"
  }
}


# Create my_igw

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my_igw"
  }
}

# Creating route_table for Public subnets

resource "aws_route_table" "Public_Route_table" {
    vpc_id = aws_vpc.my_vpc.id


route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}
# create elastic ip

resource "aws_eip" "Elastic_Ip" {
    domain = "vpc"

    tags = {
        name = "my_elastic_ip"
    }
}

#create natgaweway

resource "aws_nat_gateway" "my_natgw" {
    allocation_id = aws_eip.my_elastic_ip.id
    subnet_id = aws_subnet.public_subnet_1a.id

}

# create route_table for private subnets

resource "aws_route_table" "private_Route_table" {
    vpc_id = aws_vpc.my_vpc.id


route { 
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_natgw.id
}

route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_natgw.id

}
}


#Association of routetables to subnets

resource "aws_route_table_association" "subnet_1a_public_association" {
    subnet_id = aws_subnet.public_subnet_1a.id
    route_table_id = aws_route_table.Public_Route_table.id
}

resource "aws_route_table_association" "subnet_1b__public_association" {
    subnet_id = aws_subnet.public_subnet_1b.id
    route_table_id = aws_route_table.Public_Route_table.id
}

resource "aws_route_table_association" "subnet_1a__private_association" {
    subnet_id = aws_subnet.private_subnet_1a.id
    route_table_id = aws_route_table.private_Route_table.id
}

resource "aws_route_table_association" "subnet_1b_private_association" {
    subnet_id = aws_subnet.public_subnet_1b.id
    route_table_id = aws_route_table.Public_Route_table.id
}
