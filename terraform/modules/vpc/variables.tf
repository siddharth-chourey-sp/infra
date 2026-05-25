variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default = "10.0.0.0/16"
}

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


variable "azs" {
  description = "List of availability zones for the subnets"
  type        = list(string)
  default     = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
}

variable "common_tags" {
  type = map(string)
  default = {
    Project     = "devops-project"
    Environment = "dev"
    Owner       = "sid"
    ManagedBy   = "terraform"
    Application  = "web-app"
  }
}