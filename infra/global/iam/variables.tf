variable "aws_role_arn" {
  type        = "string"
  description = "AWS ARN for role to assume"
  default     = "arn:aws:iam::584964217758:role/OrganizationAccountAccessRole"
}

data "aws_iam_policy_document" "ecs_instance_policy" {
  statement {
    sid = "1"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy" "ecs_service_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}
