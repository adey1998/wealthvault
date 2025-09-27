# Block any kind of public access (must-have for compliance)
resource "aws_s3_bucket_public_access_block" "demo_block" {
    bucket                  = aws_s3_bucket.demo.id
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}

# Encrypt all objects at rest (AES256 managed by AWS)
resource "aws_s3_bucket_server_side_encryption_configuration" "demo_sse" {
    bucket  = aws_s3_bucket.demo.id
    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}

# Enable versioning (so we can roll back deletes/overwrites)
resource "aws_s3_bucket_versioning" "demo_versioning" {
    bucket = aws_s3_bucket.demo.id
    versioning_configuration {
        status = "Enabled"
    }
}