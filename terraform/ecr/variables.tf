variable "app_name" {
  type = string
  default = "g4gov"
}

variable "ecr_repositories" {
  type = list(string)
  default = ["901935996178.dkr.ecr.eu-central-1.amazonaws.com/frontend", "901935996178.dkr.ecr.eu-central-1.amazonaws.com/backend"]
}

variable "environment" {
  description = "dev"
}
