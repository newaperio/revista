provider "aws" {
  version = "~> 1.42"

  assume_role {
    role_arn     = "${var.aws_role_arn}"
    session_name = "terraform-revista-global-route53"
  }
}

resource "aws_route53_zone" "prod" {
  name    = "elixirinthe.cloud"
  comment = "Prod main domain for Revista, managed by Terraform"

  tags {
    name = "rv-prod-main"
    Env  = "prod"
  }
}
