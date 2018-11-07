output "prod_zone_id" {
  description = "Route53 zone ID for prod domain"
  value       = "${aws_route53_zone.prod.zone_id}"
}

output "prod_name_servers" {
  description = "Name servers for prod domain"
  value       = "${aws_route53_zone.prod.name_servers}"
}
