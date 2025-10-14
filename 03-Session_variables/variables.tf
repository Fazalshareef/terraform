

variable "vpc_01_cidr" {
  description = "cidr range for the vpc_01"
  type        = string
  default     = "10.0.0.0/16"
}


variable "vpc_02_cidr" {
  description = "cidr range for the vpc_02"
  type        = string
  default     = "198.16.0.0/16"
}


variable "project_name" {
  description = "name tag of the vpc"
  type        = string
  default     = "Shareef_Agro_Agencies"
}

variable "environment" {
  description = "environment of the current project"
  type        = string
  default     = "production"

}

variable "us_east_1a_zone" {
  description = "1st avaliability zone consider as us-east-1a"
  type        = string
  default     = "us-east-1a"
}

variable "us_east_1b_zone" {
  description = "2nd avaliability zone consider as us-east-1b"
  type        = string
  default     = "us-east-1b"
}

