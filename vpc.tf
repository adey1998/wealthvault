locals {
  project = "wealthvault"
  env     = "dev"
  name    = "${local.project}-${local.env}"
}

# Create a VPC with public + private subnets across 2 AZs
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = local.name
  cidr = "10.0.0.0/16"

  # Two Availability Zones in us-east-1
  azs = ["us-east-1a", "us-east-1b"]

  # Public subnets (for ALB, NAT)
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

  # Private subnets (for ECS app + RDS later)
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}

# Helpful outputs after apply
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}