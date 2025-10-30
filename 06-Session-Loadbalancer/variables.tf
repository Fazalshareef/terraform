variable "instance_ami_id" {
    description = "AWS linux ami id"
    type = string
    default = "ami-07860a2d7eb515d9a"
}

variable = "instance_type" {
    description = "instance type has been t3.micro"
    type = string
    default = "t3.micro"
}

variable = "key_name" {
    description = "acess key details"
    type = string
    default = "USA.pem"
}