# Security group for ALB (Application Load Balancer): allow HTTP from the internet
resource "aws_security_group" "alb_sg" {
  name        = "wealthvault-alb-sg"
  description = "Allow HTTP from anywhere to the ALB"
  vpc_id      = module.vpc.vpc_id # use your VPC from vpc.tf

  # Inbound: anyone on the internet can hit port 80 (HTTP)
  ingress {
    description = "HTTP in"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound: ALB can talk out to anything (default safe for ALB)
  egress {
    description = "All out"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}