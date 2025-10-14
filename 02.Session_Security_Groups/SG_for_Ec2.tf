resource "aws_instance" "amazon_linux" {

  ami                         = "ami-052064a798f08f0d3"
  instance_type               = "t3.micro"
  vpc_security_group_ids      = [aws_security_group.my_security_group.id]
  key_name                    = "USA"
  subnet_id                   = "subnet-03a322b1c5fef346e"
  associate_public_ip_address = true

  tags = {
    name = "my_ec2"
  }
}






resource "aws_security_group" "my_security_group" {
  name        = "allow_all_tcs"
  description = " allow all egress and only TCp ingress"
  vpc_id      = "vpc-0e39a43943e04fa08"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

