variable "name" {
  description = "Name of the ALB"
}

variable "environment" {
  description = "Name of the enviroment"
}

variable "subnets" {
  description = "Public CIDR's list"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "alb_security_groups" {
  description = "Comma separated list of security groups"
}

variable "alb_tls_cert_arn" {
  description = "The ARN of the certificate that the ALB uses for https"
  default = "arn:aws:acm:eu-central-1:901935996178:certificate/ff8059b6-f9f3-4dec-898f-a6d0bbc8ad74"
}


variable "health_check_front" {
  description = "Path to check if the front-end service is healthy"
  # default = "/"
}

variable "health_check_back" {
  description = "Path to check if the service is healthy"
  # default = "/health"
}

