resource "aws_instance" "web" {
 ami                    = "ami-0cbbe2c6a1bb2ad63"
 instance_type          = "t2.micro"
 vpc_security_group_ids = [aws_security_group.Allow_all.id]


 tags = {
   Name = "Creating Terraform"
 }
}


resource "aws_security_group" "Allow_all" {
 name        = var.security_group_name
 description = var.description


 ingress {
   description = "Allowing all ports"
   from_port   = var.port_number
   to_port     = var.port_number
   protocol    = "tcp"
   cidr_blocks = var.cidr_blocks
   #ipv6_cidr_blocks = ["::/0"]
 }


 egress {
   from_port   = var.port_number
   to_port     = var.port_number
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
   #ipv6_cidr_blocks = ["::/0"]
 }
 tags = {
   name = "allowing all the traffic"
 }
}
