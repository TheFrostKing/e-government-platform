variable "name" {
  description = "g4gov"
}

variable "environment" {
  description = "Production"
}

variable "aws-region" {
  type        = string
  description = "Central Europe"
}

variable "availability_zones" {
  description = "All availiability zones from Central region"
}

variable "cidr" {
  description = "The CIDR block for the VPC."
}

variable "private_subnets" {
  description = "Private CIDR's list"
}

variable "public_subnets" {
  description = "Public CIDR's list"
}

variable "database_subnets" {
  description = "Database CIDR's list"
}

variable "graylog_subnets" {
  description = "Graylog CIDR's list"
}

variable "service_desired_count" {
  description = "Number of tasks running in parallel"
}

variable "front_container_port" {
  description = "Port of the front-end container"
}

variable "back_container_port" {
  description = "Port of back-end container"
}

variable "front_container_cpu" {
  description = "The number of cpu units used by the front-end task"
}

variable "back_container_cpu" {
  description = "The number of cpu units used by the back-end task"
}

variable "front_container_memory" {
  description = "The amount (in MiB) of memory used by the front-end task"
}

variable "back_container_memory" {
  description = "The amount (in MiB) of memory used by the back-end task"
}

variable "front_ecr_repo" {
  description = "ECR front end repository"
}

variable "back_ecr_repo" {
  description = "ECR back end repository"
}

variable "health_check_front" {
  description = "Path to check if the front-end service is healthy"
}

variable "health_check_back" {
  description = "Path to check if the back-end service is healthy"
}

variable "url_name" {
  description = "Name of the URL"
}

variable "tsl_certificate_arn" {
  description = "The ARN of the certificate that the ALB uses for https"
}

variable "db_password" {
  description = "RDS root user password"
  sensitive   = true
}

