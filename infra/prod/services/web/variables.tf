variable "env" {
  type        = "string"
  description = "Environment name"
  default     = "prod"
}

variable "name_prefix" {
  type        = "string"
  description = "Prefix for naming resources"
  default     = "rv-prod-web"
}

variable "aws_role_arn" {
  type        = "string"
  description = "AWS ARN for role to assume"
  default     = "arn:aws:iam::584964217758:role/OrganizationAccountAccessRole"
}

variable "vpc_id" {
  description = "ID of VPC to create DB subnet in"
  default     = "vpc-06a9b4b640af11fa0"
}

variable "zone_id" {
  description = "Route53 zone ID"
  default     = "Z3LSDY5O3V2OT"
}

data "aws_vpc" "this" {
  id = "${var.vpc_id}"
}

data "aws_subnet_ids" "this" {
  vpc_id = "${data.aws_vpc.this.id}"
}

data "aws_ami" "ecs" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }
}

data "aws_iam_instance_profile" "ecs" {
  name = "ecs-instance-profile"
}

data "aws_route53_zone" "this" {
  zone_id = "${var.zone_id}"
}
