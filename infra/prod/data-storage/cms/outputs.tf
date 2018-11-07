output "database_address" {
  value       = "${aws_db_instance.this.address}"
  description = "Hostname of RDS instance"
}

output "database_name" {
  value       = "${aws_db_instance.this.name}"
  description = "Name of database on RDS instance"
}

output "database_username" {
  value       = "${aws_db_instance.this.username}"
  description = "Username of database on RDS instance"
}

output "database_password" {
  value       = "${aws_db_instance.this.password}"
  description = "Password of database on RDS instance"
}
