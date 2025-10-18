# CREATING THE EC2 Instances 

resource "aws_instance" "ec-2" {
  count                  = 3
  ami                    = var.ami_id
  vpc_security_group_ids = [aws_security_group.allow_tls_http.id]
  instance_type          = var.instance_type_map[var.environment]
  subnet_id = "subnet-0a81536e478f7d392"
  tags = {
    Name        = "${var.instance_name[count.index]}-${var.project_name}" 
    Environment = var.environment
  }
}


resource "aws_security_group" "allow_tls_http" {
  name        = "allow_ssh_http"
  description = "allow TLS and http inbound and all out bound traffic"
  vpc_id = "vpc-035d7c83be5d51002"

  ingress {
    description = "tcp from anywhere"
    from_port  = 22
    to_port    = 22
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "http for anywhere"
    from_port  = 80
    to_port    = 80
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.project_name
  }
}