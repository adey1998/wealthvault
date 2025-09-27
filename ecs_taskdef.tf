# Task definition = the recipe for ONE container task
resource "aws_ecs_task_definition" "app" {
     family                     = "wealthvault-app"     # name of the task definition family
     requires_compatibilities   = ["FARGATE"]           # we're using serverless Fargate
     network_mode               = "awsvpc"              # required by Fargate
     cpu                        = "256"                 # 1/4 vCPU
     memory                     = "512"                 # 0.5 GB RAM
     execution_role_arn         = aws_iam_role.task_execution.arn

     # One container: nginx listening to port 80, logs to CloudWatch
     container_definitions = jsonencode([
        {
            name        = "app",
            image       = "public.ecr.aws/docker/library/nginx:stable",
            essential   = true,
            portMappings = [
                { containerPort = 80, protocol = "tcp" }
            ],
            logConfiguration = {
                logDriver = "awslogs",
                options = {
                    awslogs-group           = aws_cloudwatch_log_group.ecs.name,
                    awslogs-region          = "us-east-1",
                    awslogs-stream-prefix   = "app"
                }
            }
        }
     ])
}

# Handy output
output "task_definition_arn" {
    value = aws_ecs_task_definition.app.arn
}