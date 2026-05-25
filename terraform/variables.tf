variable "region" {
  description = "AWS region"
  default     = "ap-southeast-2"
}

variable "environment" {
  description = "Deployment environment"
  default     = "dev"
}

variable "project" {
  description = "Project name"
  default     = "devops-project"
}

variable "db_user" {}

variable "db_name" {}

variable "public_subnets" {
  description = "map of public subnet CIDR blocks"
  type        = map(object({
    cidr = string
    az   = string
  }))
}

variable "private_subnets" {
    description = "map of private subnet CIDR blocks"
    type        = map(object({
      cidr = string
      az   = string
    }))
}
