# Declare the required version of the AWS provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.65.0"
    }
  }
}

# Configure the AWS provider with the specified region
provider "aws" {
  region                           = var.aws-region
}

# Call the "vpc" module and pass in the necessary variables
module "vpc" {
  source                           = "./vpc"
  name                             = var.name
  cidr                             = var.cidr
  private_subnets                  = var.private_subnets
  public_subnets                   = var.public_subnets
  database_subnets                 = var.database_subnets 
  graylog_subnets                  = var.graylog_subnets
  availability_zones               = var.availability_zones
  environment                      = var.environment
}

# Call the "security-groups" module and pass in the necessary variables
module "security_groups" {
  source                           = "./security-groups"
  name                             = var.name
  vpc_id                           = module.vpc.id
  environment                      = var.environment
}

# Call the "alb" module and pass in the necessary variables
module "alb" {
  source                           = "./alb"
  name                             = var.name
  vpc_id                           = module.vpc.id
  subnets                          = module.vpc.public_subnets
  environment                      = var.environment
  alb_security_groups              = [module.security_groups.alb]
  alb_tls_cert_arn                 = var.tsl_certificate_arn
  health_check_front               = var.health_check_front
  health_check_back                = var.health_check_back
}

# Call the "route53" module and pass in the necessary variables
module "route53_public_zone" {
  source                           = "./route53"
  vpc_id                           = module.vpc.id
}

# Call the "ecr" module and pass in the necessary variables
module "ecr" {
  source                           = "./ecr"
  environment                      = var.environment

}

# Call the "ecs" module and pass in the necessary variables
module "ecs" {
  source                           = "./ecs"
  name                             = var.name
  environment                      = var.environment
  region                           = var.aws-region
  ecs_service_security_groups      = [module.security_groups.ecs_front, module.security_groups.ecs_back]
  service_desired_count            = var.service_desired_count
  public_subnets                   = module.vpc.public_subnets
  private_subnets                  = module.vpc.private_subnets
  front_ecr_repo                   = var.front_ecr_repo
  back_ecr_repo                    = var.back_ecr_repo
  aws_alb_target_group_front       = module.alb.aws_alb_target_group_front
  aws_alb_target_group_back        = module.alb.aws_alb_target_group_back
}

# Call the "grafana" module and pass in the necessary variables
module "grafana" {
  source                            = "./grafana"
  subnets                           = module.vpc.public_subnets
  grafana_service_security_groups   = [module.security_groups.grafana]

}

# Call the "graylog" module and pass in the necessary variables
module "graylog" {
  source                            = "./graylog"
  vpc_id                            = module.vpc.id
  graylog_subnets                   = module.vpc.graylog_subnets 
  graylog_service_security_groups   = [module.security_groups.graylog]
}

# Call the "jenkins" module and pass in the necessary variables
module "jenkins" {
  source                            = "./jenkins"
  vpc_id                            = module.vpc.id
  graylog_subnets                   = module.vpc.graylog_subnets 
  
}

# Call the "rds" module and pass in the necessary variables
module "rds" {
  source                            = "./rds"
  vpc_id                            = module.vpc.id
  database_subnets                  = module.vpc.database_subnets
  rds_service_security_groups       = [module.security_groups.rds]
  db_password                       = var.db_password
}



