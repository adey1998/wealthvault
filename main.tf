terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_s3_bucket" "demo" {
    bucket = "wealthvault-demo-bucket-${random_string.bucket_suffix.result}"
}

resource "random_string" "bucket_suffix" {
    length  = 8
    special = false
    upper   = false
}