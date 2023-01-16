variable "name" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
}

variable "region" {
  description = "the AWS region in which resources are created"
}

variable "public_subnets" {
  description = "List of subnet IDs"
}

variable "private_subnets" {
  description = "List of subnet IDs"
}

variable "ecs_service_security_groups" {
  description = "Comma separated list of security groups"
}

variable "front_ecr_repo"{
  description = "kur1"
}

variable "back_ecr_repo"{
  description = "kur2"
}

variable "aws_alb_target_group_front"{
  description = "kur3"
}

variable "aws_alb_target_group_back"{
  description = "kur4"
}

variable "service_desired_count" {
  description = "Number of services running in parallel"
}
