# Run 2 copies of the task in PRIVATE subnets and register them in the Target Group
resource "aws_ecs_service" "app" {
    name                = "wealthvault-service"
    cluster             = aws_ecs_cluster.this.id
    task_definition     = aws_ecs_task_definition.app.arn
    desired_count       = 2
    launch_type         = "FARGATE"

    # Each task gets its own ENI inside our private subnets
    network_configuration {
        subnets             = module.vpc.private_subnets
        security_groups     = [aws_security_group.ecs_sg.id]
        assign_public_ip    = false
    }

    # Tell ALB which container/port to send traffic to, via your Target Group
    load_balancer {
        target_group_arn    = aws_lb_target_group.app_tg.arn
        container_name      = "app"
        container_port      = 80
    }

    # Make sure the target group exists before we try to register tasks to it
    depends_on = [aws_lb_target_group.app_tg, aws_lb_listener.http]
}