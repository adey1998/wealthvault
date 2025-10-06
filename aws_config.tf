# IAM role for AWS Config service
data "aws_iam_policy_document" "config_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "config_role" {
    name                = "wealthvault-aws-config-role"
    assume_role_policy  = data.aws_iam_policy_document.config_assume.json
}

# Attach AWS-managed policy with least-priv privileges for Config
# resource "aws_iam_role_policy_attachment" "config_managed" {
#     role        = aws_iam_role.config_role.name
#     policy_arn  = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
# }

resource "aws_iam_role_policy" "config_inline" {
  name = "wealthvault-aws-config-inline"
  role = aws_iam_role.config_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # Allow AWS Config to record/evaluate resources
      {
        Effect: "Allow",
        Action: [
          "config:BatchGet*",
          "config:BatchPut*",
          "config:Delete*",
          "config:Deliver*",
          "config:Describe*",
          "config:Get*",
          "config:List*",
          "config:Put*"
        ],
        Resource: "*"
      },
      # Allow writes to your audit bucket (you already created it)
      {
        Effect: "Allow",
        Action: ["s3:GetBucketAcl", "s3:ListBucket", "s3:PutObject"],
        Resource: [
          aws_s3_bucket.audit_logs.arn,
          "${aws_s3_bucket.audit_logs.arn}/*"
        ]
      },
      # If you ever wire SNS notifications for Config evaluations
      { Effect: "Allow", Action: ["sns:Publish"], Resource: "*" }
    ]
  })
}


# Use the same audit bucket, store under a prefix
resource "aws_config_delivery_channel" "main" {
    name           = "wealthvault-config-channel"
    s3_bucket_name = aws_s3_bucket.audit_logs.bucket
    s3_key_prefix  = "aws-config"
    depends_on     = [aws_iam_role_policy.config_inline]
}


# Record all supported resource types in all regions
resource "aws_config_configuration_recorder" "main" {
    name        = "wealthvault-config-recorder"
    role_arn    = aws_iam_role.config_role.arn

    recording_group {
        all_supported                   = true
        include_global_resource_types   = true
    }
}

# Turn the recorder ON
resource "aws_config_configuration_recorder_status" "main" {
    name            = aws_config_configuration_recorder.main.name
    is_enabled      = true
    depends_on      = [aws_config_delivery_channel.main]
}

# A few high-value managed rules (simple, useful)

# Ensure CloudTrail is enabled (the trail we just made)
resource "aws_config_config_rule" "cloudtrail_enabled" {
    name = "cloudtrail-enabled"
    source {
        owner               = "AWS"
        source_identifier   = "CLOUD_TRAIL_ENABLED"
    }
    depends_on = [aws_config_configuration_recorder_status.main]
}

# S3 buckets must be encrypted
resource "aws_config_config_rule" "s3_encrypted" {
    name = "s3-bucket-server-side-encryption-enabled"
    source {
        owner             = "AWS"
        source_identifier = "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"
    }
    depends_on = [aws_config_configuration_recorder_status.main]
}

# S3 buckets must block public read
resource "aws_config_config_rule" "s3_no_public_read" {
    name = "s3-bucket-public-read-prohibited"
    source {
        owner               = "AWS"
        source_identifier   = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
    }
    depends_on = [aws_config_configuration_recorder_status.main]
}