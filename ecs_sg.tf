# Security group for ECS tasks: only allow HTTP from the ALB SG
resource "aws_security_group" "ecs_sg" {
    name        = "wealthvault-ecs-sg"
    description = "Allow HTTP from ALB to ECS tasks"
    vpc_id      = module.vpc.vpc_id

    # Inbound: port 80 only from the ALB's security group
    ingress {
        description     = "From ALB only"
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        security_groups = [aws_security_group.alb_sg.id]
    }

    # Outbound: allow all (needed so tasks can reach the internet via NAT)
    egress {
        description     = "All egress"
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }
}