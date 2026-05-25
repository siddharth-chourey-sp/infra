variable "db_subnet_ids" {
    type = list(string)
}
variable "vpc_id" {
    type = string
}
variable "db_sg_id" {
    type = string
}
variable "db_username" {
    type = string
}

variable "db_name" {
    type = string
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
