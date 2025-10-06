# Store database credentials securely in Secrets Manager

# Create the secret container (like creating an empty vault)
resource "aws_secretsmanager_secret" "db" {
    name        = "wealthvault-db-credentials"
    description = "Credentials for the WealthVault PostgreSQL database"
}

# Add username & password to secret (actual secret data)
resource "aws_secretsmanager_secret_version" "db_v1" {
    secret_id   = aws_secretsmanager_secret.db.id

    # This JSON is what gets encrypted and stored
    secret_string   = jsonencode({
        username    = "wv_app"
        password    = "12345"
    })
}

# Output secret ARN for reference
output "db_secret_arn" {
    value   = aws_secretsmanager_secret.db.arn
}