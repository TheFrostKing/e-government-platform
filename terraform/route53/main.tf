# Use pre-made module for creation of Public DNS zone
module "public_hosted_zone" {
  source  = "brunordias/route53-zone/aws"
  version = "~> 1.0.0"

  domain      = "g4egov.com"
  description = "Created by a Terraform module"
  tags = {
    environment = "development"
  }
}

