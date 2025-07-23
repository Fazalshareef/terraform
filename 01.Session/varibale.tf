variable "security_group_name" {
 default = "allow_all_aws"
}


variable "description" {
 default = "All all the traffic"
}


variable "port_number" {
 default = "0"


}


variable "cidr_blocks" {
 type    = list(any)
 default = ["0.0.0.0/0"]
}
