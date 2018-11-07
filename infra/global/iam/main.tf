provider "aws" {
  version = "~> 1.42"

  assume_role {
    role_arn     = "${var.aws_role_arn}"
    session_name = "terraform-revista-global-iam"
  }
}

resource "aws_iam_role" "ecs_instance_role" {
  name               = "ecs-instance-role"
  path               = "/ecs/"
  description        = "Allows ECS instances to call AWS services"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_instance_policy.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_attachment" {
  role       = "${aws_iam_role.ecs_instance_role.name}"
  policy_arn = "${data.aws_iam_policy.ecs_service_policy.arn}"
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecs-instance-profile"
  path = "/ecs/"
  role = "${aws_iam_role.ecs_instance_role.name}"
}
