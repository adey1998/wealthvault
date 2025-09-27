# S3 bucket to store CloudTrail logs (private, versioned, encrypted)
resource "aws_s3_bucket" "audit_logs" {
    bucket = "wealthvault-audit-logs-${random_string.bucket_suffix.result}"
}

resource "aws_s3_bucket_public_access_block" "audit_logs_block" {
    bucket                  = aws_s3_bucket.audit_logs.id
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "audit_logs_versioning" {
    bucket = aws_s3_bucket.audit_logs.id
    versioning_configuration { 
        status = "Enabled" 
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "audit_logs_sse" {
    bucket = aws_s3_bucket.audit_logs.id
    rule {
        apply_server_side_encryption_by_default { 
            sse_algorithm = "AES256" 
        }
    }
}

# Allow CloudTrail service to write into the bucket
data "aws_caller_identity" "me" {}

resource "aws_s3_bucket_policy" "audit_logs_policy" {
    bucket = aws_s3_bucket.audit_logs.id
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Sid      = "CloudTrailS3AclCheck",
                Effect   = "Allow",
                Principal = { 
                    Service = "cloudtrail.amazonaws.com" 
                },
                Action   = "s3:GetBucketAcl",
                Resource = aws_s3_bucket.audit_logs.arn
            },
            {
                Sid      = "CloudTrailWrite",
                Effect   = "Allow",
                Principal = { 
                    Service = "cloudtrail.amazonaws.com" 
                },
                Action   = "s3:PutObject",
                Resource = "${aws_s3_bucket.audit_logs.arn}/AWSLogs/${data.aws_caller_identity.me.account_id}/*",
                Condition = {
                    StringEquals = { "s3:x-amz-acl" = "bucket-owner-full-control" }
                }
            }
        ]
    })
}

# The CloudTrail trail itself (multi-region, validated)
resource "aws_cloudtrail" "main" {
    name                          = "wealthvault-trail"
    s3_bucket_name                = aws_s3_bucket.audit_logs.bucket
    include_global_service_events = true
    is_multi_region_trail         = true
    enable_log_file_validation    = true

    depends_on = [aws_s3_bucket_policy.audit_logs_policy]
}

# Handy output
output "cloudtrail_logs_bucket" {
    value = aws_s3_bucket.audit_logs.bucket
}