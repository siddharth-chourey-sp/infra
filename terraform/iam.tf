resource "aws_iam_role" "ec2_iam_role" {
  name = "ec2-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }

}
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-profile"
  role = aws_iam_role.ec2_iam_role.id

  tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}


resource "aws_iam_policy" "secrets_policy" {
  name = "secrets-access-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["secretsmanager:GetSecretValue"],
      Resource = module.rds.db_secrets_arn
    }]
  })

  tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

locals {
 iam_policies = {
    ssm = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    secrets = aws_iam_policy.secrets_policy.arn
  }
}

resource "aws_iam_role_policy_attachment" "attachments" {
  for_each = local.iam_policies

  role = aws_iam_role.ec2_iam_role.name
  policy_arn = each.value
}