# 1. Register the ECS service with Application Auto Scaling
resource "aws_appautoscaling_target" "ecs" {
    service_namespace   = "ecs"
    resource_id         = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.app.name}"
    scalable_dimension  = "ecs:service:DesiredCount"

    min_capacity = 2    # keep HA (2 tasks across AZs)
    max_capacity = 6    # cap spend
}

# 2. Target tracking policy: keep average CPU ~50%
resource "aws_appautoscaling_policy" "ecs_cpu_tt" {
    name               = "wealthvault-ecs-cpu-tt"
    policy_type        = "TargetTrackingScaling"
    service_namespace  = aws_appautoscaling_target.ecs.service_namespace
    resource_id        = aws_appautoscaling_target.ecs.resource_id
    scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension

    target_tracking_scaling_policy_configuration {
        target_value    = 50.0  # aim for ~50% avg CPU
        predefined_metric_specification {
            predefined_metric_type = "ECSServiceAverageCPUUtilization"
        }
        scale_in_cooldown   = 60
        scale_out_cooldown  = 60
    }

    depends_on = [aws_appautoscaling_target.ecs]
}