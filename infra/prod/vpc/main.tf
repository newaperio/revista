provider "aws" {
  version = "~> 1.42"

  assume_role {
    role_arn     = "${var.aws_role_arn}"
    session_name = "terraform-revista-prod-vpc"
  }
}

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"

  tags {
    Name = "${var.name_prefix}"
    Env  = "${var.env}"
  }
}

resource "aws_subnet" "this" {
  count             = "${var.public_subnets}"
  vpc_id            = "${aws_vpc.this.id}"
  cidr_block        = "${cidrsubnet("${aws_vpc.this.cidr_block}", 8, count.index)}"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"

  tags {
    Name = "${var.name_prefix}-${element(split("-", element(data.aws_availability_zones.available.names, count.index)), 2)}"
    Env  = "${var.env}"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = "${aws_vpc.this.id}"

  tags {
    Name = "${var.name_prefix}"
    Env  = "${var.env}"
  }
}

resource "aws_route_table" "this" {
  vpc_id = "${aws_vpc.this.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.this.id}"
  }

  tags {
    Name = "${var.name_prefix}-public"
    Env  = "${var.env}"
  }
}

resource "aws_route_table_association" "this" {
  count          = "${var.public_subnets}"
  subnet_id      = "${element(aws_subnet.this.*.id, count.index)}"
  route_table_id = "${aws_route_table.this.id}"
}
