variable "vpc_id" {
  description = "VPC ID"
}

variable "graylog_subnets" {
  description = "List of private subnets"
}

variable "graylog_service_security_groups" {
  description = "Comma separated list of security groups"
}

variable "name" {
  default = "graylog"
}

variable "ami_id" {
  default = "ami-08f05d789c20c6144"
}

variable "instance" {
  default = "t2.medium"
}

variable "key_name" {
  default = "virtual-key"
}

