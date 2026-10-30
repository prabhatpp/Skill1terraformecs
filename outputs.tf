output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = [for subnet in values(aws_subnet.public) : subnet.id]
}

output "private_subnet_ids" {
  value = [for subnet in values(aws_subnet.private) : subnet.id]
}

output "internal_alb_dns_name" {
  value = aws_lb.internal.dns_name
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.app.domain_name
}

output "rds_endpoint" {
  value = aws_db_instance.postgres.address
}

output "redis_endpoint" {
  value = aws_elasticache_replication_group.redis.primary_endpoint_address
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "sns_topic_arn" {
  value = aws_sns_topic.alerts.arn
}
