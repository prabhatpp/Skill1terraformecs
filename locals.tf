locals {
  common_tags = {
    Project     = var.project_name
    ManagedBy   = "terraform"
    Environment = "prod"
  }

  private_az_map = {
    "us-east-1a" = [var.private_subnet_cidrs[0], var.private_subnet_cidrs[1]]
    "us-east-1b" = [var.private_subnet_cidrs[2], var.private_subnet_cidrs[3]]
    "us-east-1c" = [var.private_subnet_cidrs[4], var.private_subnet_cidrs[5]]
  }
}
