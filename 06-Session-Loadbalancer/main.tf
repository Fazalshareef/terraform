


module "vpc" {
  source         = "git::https://github.com/Fazalshareef/terraform.git//07-Session_VPC_Module"
  vpc_name_tag       = "terraform_vpc"
  vpc_cidr       = "172.16.0.0/16"
  public_subnet_cidrs = ["172.16.1.0/24", "172.16.2.0/24"]
  azs            = ["us-east-1a", "us-east-1b"]

}

resource "aws_instance" "web" {
    count = 2
ami = var.ami_id
instance_type = var.insatnce_type
vpc_id = aws_vpc.terraform_vpc.id
subnet_id = aws_subnet.subnets.id
key_name = "var.key_name"



}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = data.aws_security_group.default.id
}

resource "target_group" "testing" {
    
}