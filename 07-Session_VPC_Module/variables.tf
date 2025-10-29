variable "vpc_cidr" {
  description = "VPC CIDR block"
  type = string
}

variable "vpc_name_tag" {
  description = "variable name"
  type = string
}


variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "azs" {
  description = "list of availability_zones"
  type = list(string)

}