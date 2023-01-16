variable "myami" {
    default = "ami-070b208e993b59cea"
}

variable "instancetype" {
    default = "t3a.medium"
}

variable "tag" {
    default =  "Jenkins_Server" 
}

variable "jenkins-sg" {
    default = "jenkins-server-sec-gr"
}

variable "region" {
    default = "eu-central-1"   
}

variable "aim_role_name" {
    default = "terra-jenkins"
}

variable "aim_profile_name" {
    default = "jenkins-terra-profile"
}

variable "profile" {
    default = "default"
}

variable "vpc_id" {
    description = "The VPC ID"
}

variable "graylog_subnets" {
  description = "List of private subnets"
}
