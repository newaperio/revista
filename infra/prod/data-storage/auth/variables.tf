variable "env" {
  type        = "string"
  description = "Environment name"
  default     = "prod"
}

variable "name_prefix" {
  type        = "string"
  description = "Prefix for naming resources"
  default     = "rv-prod-auth"
}

variable "aws_role_arn" {
  type        = "string"
  description = "AWS ARN for role to assume"
  default     = "arn:aws:iam::584964217758:role/OrganizationAccountAccessRole"
}

variable "aws_availability_zone" {
  type        = "string"
  description = "AWS availability zone"
  default     = "us-east-1a"
}

variable "aws_ecs_security_group_id" {
  type        = "string"
  description = "ID of security group for ECS cluster traffic"
}

variable "vpc_id" {
  description = "ID of VPC to create DB subnet in"
}

variable "rds_password" {
  description = "Password for the RDS instance"
}

data "aws_vpc" "this" {
  id = "${var.vpc_id}"
}

data "aws_subnet_ids" "this" {
  vpc_id = "${data.aws_vpc.this.id}"
}

data "aws_security_group" "cluster" {
  id = "${var.aws_ecs_security_group_id}"
}
