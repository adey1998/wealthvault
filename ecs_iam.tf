# Allow ECS tasks to assume this role
data "aws_iam_policy_document" "ecs_task_assume" {
    statement {
        actions = ["sts:AssumeRole"]
        principals {
            type        = "Service"
            identifiers = ["ecs-tasks.amazonaws.com"]
        }
    }
}

# Execution role used by the ECS agent (pull image, fetch secrets, send logs)
resource "aws_iam_role" "task_execution" {
    name                = "wealthvault-task-execution"
    assume_role_policy  = data.aws_iam_policy_document.ecs_task_assume.json
}

# Attach AWS-managed permissions for ECS task execution
resource "aws_iam_role_policy_attachment" "task_exec_attach" {
    role            = aws_iam_role.task_execution.name
    policy_arn      = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Output so we can see the role name/ARN after apply
output "ecs_task_execution_role_arn" {
    value = aws_iam_role.task_execution.arn
}