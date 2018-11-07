provider "aws" {
  version = "~> 1.42"

  assume_role {
    role_arn     = "${var.aws_role_arn}"
    session_name = "terraform-revista-prod-data-storage-auth"
  }
}

resource "aws_security_group" "this" {
  name        = "${var.name_prefix}"
  description = "Prod main security group for auth database"
  vpc_id      = "${data.aws_vpc.this.id}"

  tags {
    Name = "${var.name_prefix}"
    Env  = "${var.env}"
  }
}

resource "aws_security_group_rule" "allow_all_egress" {
  security_group_id = "${aws_security_group.this.id}"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_cluster_ingress" {
  security_group_id        = "${aws_security_group.this.id}"
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = "${data.aws_security_group.cluster.id}"
  description              = "Cluster"
}

resource "aws_db_subnet_group" "this" {
  name        = "${var.name_prefix}"
  description = "Prod main subnet for auth database"
  subnet_ids  = ["${data.aws_subnet_ids.this.ids}"]

  tags {
    Name = "${var.name_prefix}"
    Env  = "${var.env}"
  }
}

resource "aws_db_instance" "this" {
  allocated_storage          = 10
  auto_minor_version_upgrade = true
  availability_zone          = "${var.aws_availability_zone}"
  db_subnet_group_name       = "${aws_db_subnet_group.this.name}"
  engine                     = "postgres"
  engine_version             = "10.3"
  identifier                 = "auth"
  instance_class             = "db.t2.micro"
  name                       = "auth_prod"
  password                   = "${var.rds_password}"
  storage_type               = "gp2"
  username                   = "revista"
  vpc_security_group_ids     = ["${aws_security_group.this.id}"]

  tags {
    Name = "${var.name_prefix}"
    Env  = "${var.env}"
  }

  lifecycle {
    prevent_destroy = true
  }
}
