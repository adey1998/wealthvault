# Store database credentials securely in Secrets Manager

# Strong DB password that avoids forbidden chars (/, ", @)
resource "random_password" "db" {
    length           = 20
    special          = true
    min_upper        = 1
    min_lower        = 1
    min_numeric      = 1
    min_special      = 1
    override_special = "!#$%^&*()-_=+.,?"  # safe set for RDS
}


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
        password    = random_password.db.result
    })
}

# Output secret ARN for reference
output "db_secret_arn" {
    value   = aws_secretsmanager_secret.db.arn
}