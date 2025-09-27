terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS provider
provider "aws" {
  region = "us-east-1"
}

# Create an S3 bucket resource
resource "aws_s3_bucket" "demo" {
  bucket = "wealthvault-demo-bucket-${random_string.bucket_suffix.result}"
}

# Generate a random string to avoid bucket name collisions
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}