provider "aws" {
  version = "~> 1.42"

  assume_role {
    role_arn     = "${var.aws_role_arn}"
    session_name = "terraform-revista-global-ecr"
  }
}

resource "aws_ecr_repository" "this" {
  name = "newaperio/revista"
}

resource "aws_ecr_lifecycle_policy" "expire_policy" {
  repository = "${aws_ecr_repository.this.name}"

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 10,
      "description": "Expire images older than 14 days",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 14
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}
