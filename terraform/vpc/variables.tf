variable "name" {
  description = "the name of the stack"
}

variable "environment" {
  description = "the name of the environment "
}

variable "cidr" {
  description = "The CIDR block for the VPC."
}

variable "public_subnets" {
  description = "List of public subnets"
}

variable "private_subnets" {
  description = "List of private subnets"
}

variable "database_subnets" {
  description = "Database subnetes"
}

variable "graylog_subnets" {
  description = "Database subnetes"
}

variable "availability_zones" {
  description = "List of availability zones"
}

