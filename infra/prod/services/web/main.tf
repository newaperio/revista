provider "aws" {
  version = "~> 1.42"

  assume_role {
    role_arn     = "${var.aws_role_arn}"
    session_name = "terraform-revista-prod-services-web"
  }
}

resource "aws_security_group" "lb" {
  name        = "${var.name_prefix}-load-balancer"
  description = "Prod web load balancer"
  vpc_id      = "${data.aws_vpc.this.id}"

  tags {
    Name = "${var.name_prefix}-load-balancer"
    Env  = "${var.env}"
  }
}

resource "aws_security_group_rule" "lb_allow_all_egress" {
  security_group_id = "${aws_security_group.lb.id}"
  type              = "egress"
  from_port         = "-1"
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all egress"
}

resource "aws_security_group_rule" "lb_allow_http_ingress" {
  security_group_id = "${aws_security_group.lb.id}"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow HTTP"
}

resource "aws_security_group_rule" "lb_allow_http_ipv6_ingress" {
  security_group_id = "${aws_security_group.lb.id}"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow HTTP IPV6"
}

resource "aws_security_group_rule" "lb_allow_https_ingress" {
  security_group_id = "${aws_security_group.lb.id}"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow HTTPS"
}

resource "aws_security_group_rule" "lb_allow_https_ipv6_ingress" {
  security_group_id = "${aws_security_group.lb.id}"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow HTTPS IPV6"
}

resource "aws_lb" "this" {
  name               = "${var.name_prefix}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.lb.id}"]
  subnets            = ["${data.aws_subnet_ids.this.ids}"]
  ip_address_type    = "ipv4"

  tags {
    Name = "${var.name_prefix}"
    Env  = "${var.env}"
  }
}

resource "aws_lb_target_group" "web" {
  name        = "${var.name_prefix}-web"
  port        = 4000
  protocol    = "HTTP"
  vpc_id      = "${data.aws_vpc.this.id}"
  target_type = "instance"

  health_check {
    interval            = 30
    path                = "/healthcheck"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = 200
  }

  tags {
    Name = "${var.name_prefix}-web"
    Env  = "${var.env}"
  }
}

resource "aws_lb_target_group" "twitter" {
  name        = "${var.name_prefix}-twitter"
  port        = 4001
  protocol    = "HTTP"
  vpc_id      = "${data.aws_vpc.this.id}"
  target_type = "instance"

  health_check {
    interval            = 30
    path                = "/healthcheck"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = 200
  }

  tags {
    Name = "${var.name_prefix}-twitter"
    Env  = "${var.env}"
  }
}

resource "aws_lb_target_group" "admin" {
  name        = "${var.name_prefix}-admin"
  port        = 4002
  protocol    = "HTTP"
  vpc_id      = "${data.aws_vpc.this.id}"
  target_type = "instance"

  health_check {
    interval            = 30
    path                = "/healthcheck"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = 200
  }

  tags {
    Name = "${var.name_prefix}-admin"
    Env  = "${var.env}"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = "${aws_lb.this.arn}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.web.arn}"
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "twitter" {
  listener_arn = "${aws_lb_listener.http.arn}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.twitter.arn}"
  }

  condition {
    field  = "host-header"
    values = ["twitter.elixirinthe.cloud"]
  }
}

resource "aws_lb_listener_rule" "admin" {
  listener_arn = "${aws_lb_listener.http.arn}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.admin.arn}"
  }

  condition {
    field  = "host-header"
    values = ["admin.elixirinthe.cloud"]
  }
}

resource "aws_security_group" "ecs" {
  name        = "${var.name_prefix}-ecs-cluster"
  description = "Prod web ECS cluster"
  vpc_id      = "${data.aws_vpc.this.id}"

  tags {
    Name = "${var.name_prefix}-ecs-cluster"
    Env  = "${var.env}"
  }
}

resource "aws_security_group_rule" "ecs_allow_all_egress" {
  security_group_id = "${aws_security_group.ecs.id}"
  type              = "egress"
  from_port         = "-1"
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all egress"
}

resource "aws_security_group_rule" "ecs_allow_load_balancer_ingress" {
  security_group_id        = "${aws_security_group.ecs.id}"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = "${aws_security_group.lb.id}"
  description              = "Load balancer ingress"
}

resource "aws_cloudwatch_log_group" "this" {
  name = "${var.name_prefix}"

  tags {
    Env = "${var.env}"
  }
}

resource "aws_ecs_cluster" "this" {
  name = "${var.name_prefix}"
}

resource "aws_ecs_task_definition" "migrate_auth" {
  family                   = "${var.name_prefix}-migrate-auth"
  container_definitions    = "${file("task-definitions/migrate-auth.json")}"
  network_mode             = "bridge"
  cpu                      = 512
  memory                   = 512
  requires_compatibilities = ["EC2"]

  volume {
    name      = "app"
    host_path = "/app"
  }
}

resource "aws_ecs_task_definition" "migrate_cms" {
  family                   = "${var.name_prefix}-migrate-cms"
  container_definitions    = "${file("task-definitions/migrate-cms.json")}"
  network_mode             = "bridge"
  cpu                      = 512
  memory                   = 512
  requires_compatibilities = ["EC2"]

  volume {
    name      = "app"
    host_path = "/app"
  }
}

resource "aws_ecs_task_definition" "web" {
  family                   = "${var.name_prefix}"
  container_definitions    = "${file("task-definitions/web.json")}"
  network_mode             = "bridge"
  cpu                      = 512
  memory                   = 512
  requires_compatibilities = ["EC2"]

  volume {
    name      = "app"
    host_path = "/app"
  }
}

resource "aws_ecs_service" "web" {
  name                               = "${var.name_prefix}-web"
  cluster                            = "${aws_ecs_cluster.this.id}"
  task_definition                    = "${aws_ecs_task_definition.web.arn}"
  desired_count                      = 2
  launch_type                        = "EC2"
  scheduling_strategy                = "REPLICA"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50
  health_check_grace_period_seconds  = 0

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.web.arn}"
    container_name   = "web"
    container_port   = 4000
  }
}

resource "aws_ecs_service" "twitter" {
  name                               = "${var.name_prefix}-twitter"
  cluster                            = "${aws_ecs_cluster.this.id}"
  task_definition                    = "${aws_ecs_task_definition.web.arn}"
  desired_count                      = 1
  launch_type                        = "EC2"
  scheduling_strategy                = "REPLICA"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50
  health_check_grace_period_seconds  = 0

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.twitter.arn}"
    container_name   = "web"
    container_port   = 4001
  }
}

resource "aws_ecs_service" "admin" {
  name                               = "${var.name_prefix}-admin"
  cluster                            = "${aws_ecs_cluster.this.id}"
  task_definition                    = "${aws_ecs_task_definition.web.arn}"
  desired_count                      = 1
  launch_type                        = "EC2"
  scheduling_strategy                = "REPLICA"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50
  health_check_grace_period_seconds  = 0

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.admin.arn}"
    container_name   = "web"
    container_port   = 4002
  }
}

data "template_file" "user_data" {
  template = "${file("user-data.sh")}"

  vars {
    cluster_name = "${aws_ecs_cluster.this.name}"
  }
}

resource "aws_launch_configuration" "this" {
  name_prefix                 = "${var.name_prefix}-"
  image_id                    = "${data.aws_ami.ecs.id}"
  iam_instance_profile        = "${data.aws_iam_instance_profile.ecs.name}"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  security_groups             = ["${aws_security_group.ecs.id}"]
  user_data                   = "${data.template_file.user_data.rendered}"

  ebs_block_device {
    device_name           = "/dev/xvdcz"
    volume_type           = "gp2"
    volume_size           = "22"
    delete_on_termination = false
    encrypted             = false
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  name_prefix               = "${var.name_prefix}-"
  min_size                  = 0
  max_size                  = 5
  desired_capacity          = 5
  vpc_zone_identifier       = ["${data.aws_subnet_ids.this.ids}"]
  launch_configuration      = "${aws_launch_configuration.this.name}"
  health_check_grace_period = 0
  health_check_type         = "EC2"
  default_cooldown          = 300

  target_group_arns = [
    "${aws_lb_target_group.admin.arn}",
    "${aws_lb_target_group.twitter.arn}",
    "${aws_lb_target_group.web.arn}",
  ]

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Description"
    propagate_at_launch = true

    value = <<-DESC
    Assigned to ${aws_ecs_cluster.this.name} ECS cluster, managed by ASG
    DESC
  }

  tag {
    key                 = "Env"
    value               = "${var.env}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "apex" {
  zone_id = "${data.aws_route53_zone.this.zone_id}"
  name    = "elixirinthe.cloud"
  type    = "A"

  alias {
    name                   = "${aws_lb.this.dns_name}"
    zone_id                = "${aws_lb.this.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www" {
  zone_id = "${data.aws_route53_zone.this.zone_id}"
  name    = "www.elixirinthe.cloud"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_lb.this.dns_name}"]
}

resource "aws_route53_record" "twitter" {
  zone_id = "${data.aws_route53_zone.this.zone_id}"
  name    = "twitter.elixirinthe.cloud"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_lb.this.dns_name}"]
}

resource "aws_route53_record" "admin" {
  zone_id = "${data.aws_route53_zone.this.zone_id}"
  name    = "admin.elixirinthe.cloud"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_lb.this.dns_name}"]
}
