output "ecr_repository_url" {
  value       = "${aws_ecr_repository.this.repository_url}"
  description = "URL for ECR repository"
}
