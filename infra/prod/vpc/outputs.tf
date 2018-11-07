output "vpc_id" {
  value       = "${aws_vpc.this.id}"
  description = "ID of AWS VPC"
}

output "subnet_ids" {
  value       = "${aws_subnet.this.*.id}"
  description = "IDs for subnet created in the VPC"
}

output "subnet_cidr_blocks" {
  value       = "${aws_subnet.this.*.cidr_block}"
  description = "CIDR blocks for the subnet created in the VPC"
}
