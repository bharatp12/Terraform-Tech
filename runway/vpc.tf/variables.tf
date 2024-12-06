

variable "region" {
    type = string
    description = "the region to which infra will be deployed"
}

variable "environment" {
    type = string
    description = "the environment"
}


variable vpc_name {
    type = string
    default = "uat-vpc"
}

variable vpc_cidr {
    type = string
    default = "10.0.0.0/16"
}

variable "availability_zones" {
    type = set(string)
}

variable "nat_ip_count" {
    type = number
    default = 1
}
