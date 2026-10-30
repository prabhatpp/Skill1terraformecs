variable "aws_region" {
  description = "AWS region for the infrastructure"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "app"
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "app-cluster"
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "app"
}

variable "ecs_task_family" {
  description = "Family name for the ECS task definition"
  type        = string
  default     = "app-task"
}

variable "ecs_service_name" {
  description = "Name of the ECS service"
  type        = string
  default     = "app-service"
}

variable "ecs_container_name" {
  description = "Name of the application container in ECS"
  type        = string
  default     = "app"
}

variable "ecs_container_port" {
  description = "Port exposed by the application container"
  type        = number
  default     = 8080
}

variable "ecs_task_cpu" {
  description = "CPU units for the ECS task definition"
  type        = string
  default     = "256"
}

variable "ecs_task_memory" {
  description = "Memory for the ECS task definition"
  type        = string
  default     = "512"
}

variable "ecs_desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 2
}

variable "target_group_name" {
  description = "Name of the ALB target group"
  type        = string
  default     = "app-tg"
}

variable "target_group_health_path" {
  description = "Health check path for the ALB target group"
  type        = string
  default     = "/health"
}

variable "ecr_image_tag" {
  description = "Image tag used for the container image"
  type        = string
  default     = "latest"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (3 total)"
  type        = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
  ]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets (6 total)"
  type        = list(string)
  default = [
    "10.0.11.0/24",
    "10.0.12.0/24",
    "10.0.21.0/24",
    "10.0.22.0/24",
    "10.0.31.0/24",
    "10.0.32.0/24",
  ]
}

variable "availability_zones" {
  description = "Availability zones used across the VPC"
  type        = list(string)
  default = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c",
  ]
}

variable "db_username" {
  description = "Master username for PostgreSQL"
  type        = string
  default     = "postgresadmin"
  sensitive   = true
}

variable "db_password" {
  description = "Master password for PostgreSQL"
  type        = string
  default     = "ChangeMe123!"
  sensitive   = true
}

variable "redis_auth_token" {
  description = "Redis auth token"
  type        = string
  default     = "ChangeMeRedisToken123!"
  sensitive   = true
}

variable "redis_node_type" {
  description = "Elasticache Redis node type"
  type        = string
  default     = "cache.t3.micro"
}

variable "notification_email" {
  description = "Email address used for SNS notifications"
  type        = string
  default     = "ops@example.com"
}

variable "domain_name" {
  description = "Primary domain name for the public ALB and CloudFront certificate"
  type        = string
  default     = "example.com"
}

variable "route53_zone_id" {
  description = "Hosted zone ID for DNS validation. Leave empty to skip Route53 certificate validation."
  type        = string
  default     = ""
}

variable "internal_alb_name" {
  description = "Name of the internal ALB used for private traffic"
  type        = string
  default     = "app-internal-alb"
}

variable "internal_alb_listener_port" {
  description = "Port for the internal ALB listener"
  type        = number
  default     = 80
}

variable "internal_alb_path_patterns" {
  description = "URL path patterns routed to the internal ALB target group"
  type        = list(string)
  default     = ["/api/*", "/health", "/"]
}

variable "internal_alb_health_path" {
  description = "Health check path for the internal ALB target group"
  type        = string
  default     = "/health"
}

variable "autoscaling_min_capacity" {
  description = "Minimum ECS tasks for autoscaling"
  type        = number
  default     = 2
}

variable "autoscaling_max_capacity" {
  description = "Maximum ECS tasks for autoscaling"
  type        = number
  default     = 4
}

variable "cpu_target_utilization" {
  description = "Target CPU utilization for ECS autoscaling"
  type        = number
  default     = 70
}

variable "waf_acl_name" {
  description = "Name for the WAF Web ACL"
  type        = string
  default     = "app-cloudfront-waf"
}

variable "waf_metric_name" {
  description = "CloudWatch metric name for the WAF ACL"
  type        = string
  default     = "appCloudFrontWaf"
}

variable "s3_static_bucket_name" {
  description = "S3 bucket name for static assets"
  type        = string
  default     = "app-static-assets"
}

variable "s3_logs_bucket_name" {
  description = "S3 bucket name for CloudFront access logs"
  type        = string
  default     = "app-cloudfront-logs"
}
