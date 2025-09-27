# Target Group: where the ALB will send traffic (ECS tasks will register here later)
resource "aws_lb_target_group" "app_tg" {
  name   = "wealthvault-tg"
  vpc_id = module.vpc.vpc_id

  # We'll run containers on Fargate -> register ENIs by IP
  target_type = "ip"

  # The port on the app will listen on (nginx default)
  port     = 80
  protocol = "HTTP"

  # Health check to decide if a target is healthy
  health_check {
    path                = "/"
    matcher             = "200-499" # treat most responses as healthy for now
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 5
  }

  # Optional: faster drain on deploys
  deregistration_delay = 10
}

# Output for convenience
output "target_group_arn" {
  value = aws_lb_target_group.app_tg.arn
}