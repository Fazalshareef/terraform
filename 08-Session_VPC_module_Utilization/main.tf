
module "vpc" {
  source         = "git::https://github.com/Fazalshareef/terraform.git//07-Session_VPC_Module"
  vpc_name       = "terrafrom_vpc"
  vpc_cidr       = "10.0.0.0/16"
  public_subnets_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  azs            = ["us-east-1a", "us-east-1b"]

}