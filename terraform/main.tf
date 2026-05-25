module "vpc" {
  source = "./modules/vpc"

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "alb" {
  source = "./modules/alb"

  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  alb_sg_id      = aws_security_group.alb.id
}


locals {
  alb_ports = [80, 443]
}
resource "aws_security_group" "alb" {
  name        = "alb-sg"
  description = "Security group for ALB"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = local.alb_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ec2" {
  name   = "ec2-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "asg" {
  source = "./modules/asg"

  iam_instance_profile_name = aws_iam_instance_profile.ec2_profile.name
  private_subnets           = module.vpc.private_subnets
  target_group_arn          = module.alb.target_group_arn
  ec2_sg_id                 = aws_security_group.ec2.id
  ami_id                    = data.aws_ami.amazon_linux.id
}

resource "aws_security_group" "rds" {
  name   = "rds-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
  }

}


module "rds" {
  source = "./modules/rds"

  db_subnet_ids = module.vpc.private_subnets
  vpc_id        = module.vpc.vpc_id
  db_sg_id      = aws_security_group.rds.id
  db_username   = var.db_user
  db_name       = var.db_name

}