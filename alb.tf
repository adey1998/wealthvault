# The ALB living in the PUBLIC subnets
resource "aws_lb" "app_alb" {
  name               = "wealthvault-alb"
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets      # put ALB in public subnets
  security_groups    = [aws_security_group.alb_sg.id] # use the SG we made earlier
}

# HTTP listener: forward requests to the target group (ECS tasks)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type              = "forward"
    target_group_arn  = aws_lb_target_group.app_tg.arn
  }
}

# Handy output so we don't have to click thru the console
output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}