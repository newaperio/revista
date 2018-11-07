output "lb_dns_name" {
  value       = "${aws_lb.this.dns_name}"
  description = "DNS name of Load Balancer"
}
