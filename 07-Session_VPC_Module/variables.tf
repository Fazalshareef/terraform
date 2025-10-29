variable "vpc_cidr" {
  description = "VPC CIDR block"
  default     = {}
}

variable "vpc_name_tag" {
  description = "variable name"
  default     = {}
}

variable "public_subnet_cidrs" {
  description = "subnets cidr range"
  type = string (list)
  default     = {}
}

variable "azs" {
  description = "list of availability_zones"
  default     = {}
}