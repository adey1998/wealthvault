# ECS cluster: a logical home for your tasks/services
resource "aws_ecs_cluster" "this" {
  name = "wealthvault-cluster"
}

# CloudWatch Log Group where container logs will go
resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/wealthvault"
  retention_in_days = 7 # keep logs for a week (adjust later)
}