variable "instance_type_map" {
  description = "instance_type based on the environment"
  type        = map(string)
  default = {
    prod = "t3.micro"
    beta = "t3.small"
  }
}

variable "environment" {
  description = "Project environment"
  type        = string
  default     = "prod"
}


variable "project_name" {
  type    = string
  default = "Shareef_Agro_Agencies"
}

variable "ami_id" {
  description = "Amaozn Linux AMI ID"
  type        = string
  default     = "ami-052064a798f08f0d3"
}

variable "instance_name" {
    type = list(string)
    default = ["frontend","backend","database"]
}