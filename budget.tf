# Monthly budget
resource "aws_budgets_budget" "monthly_cost" {
    name            = "wealthvault-monthly-budget"
    budget_type     = "COST"
    limit_amount    = "25"
    limit_unit      = "USD"
    time_unit       = "MONTHLY"

    notification {
        comparison_operator         = "GREATER_THAN"
        threshold                   = 80 # 60% of budget
        threshold_type              = "PERCENTAGE"
        notification_type           = "FORECASTED"
        subscriber_email_addresses  = ["arvildey@gmail.com"]
    }
}