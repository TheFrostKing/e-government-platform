variable "db_username" {
  description = "RDS root user password"
  default = "nqkvo_ime"
}

variable "db_password" {
  description = "RDS root user password"
  sensitive   = true
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "rds_service_security_groups" {
  description = "Comma separated list of security groups"
}

variable "database_subnets" {
  description = "List of private subnets"
}
