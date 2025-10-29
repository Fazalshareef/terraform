resource "aws_instance" "web" {
    count = 2
ami_id = var.ami_id
instance_type = var.insatnce_type


}