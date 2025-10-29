variable "vpc_cidr" {
    description = "VPC CIDR block"
    default = {}
}

variable "vpc_name_tag" {
    description = "variable name"
    default = "terraform_vpc"
}

variable "public_subnet_cidrs" {
    description = "subnets cidr range"
    default = 
}

variable "azs" {
    description = "list of availability_zones"
    default = {}
}