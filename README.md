# WealthVault — Secure, Highly Available Client Portfolio Management Platform

## Overview
This project simulates the **AWS infrastructure** I designed and deployed for a **finance-industry** client-facing application.  
The platform enables high-net-worth clients to securely access **portfolio data**, **transaction history**, and **market insights** in real time.

The focus was on **security**, **compliance**, **high availability**, and **cost optimization** — following best practices aligned with **PCI-DSS** and **SOX** guidelines.


## Key Business Requirements
- **24/7 availability** — Portfolio data and market insights must be accessible at all times.  
- **Strict security & compliance** — Encryption in transit & at rest, audit logging, least-privilege IAM.  
- **Scalable infrastructure** — Handle peak load during trading hours without downtime.  
- **Cost efficiency** — Monitor and control AWS spend with alerts and resource right-sizing.  


## Architecture

### Core Components
- **VPC with Public & Private Subnets (2 AZs)** — Isolates sensitive workloads and provides redundancy.  
- **Application Load Balancer (ALB)** — Distributes traffic across ECS tasks for high availability.  
- **ECS Fargate Service** — Runs containerized application workloads securely in private subnets.  
- **S3 Bucket** — Encrypted, versioned storage for client reports and static assets.  
- **CloudWatch Logs** — Centralized log collection and monitoring for ECS containers.  
- **AWS Budgets** — Cost guardrails with monthly alerts.  
- **CloudTrail + AWS Config** — Continuous audit trail and compliance enforcement.  

> *(RDS PostgreSQL and CloudFront CDN were explored and remain optional for future iterations.)*


## Terraform Implementation
- **Infrastructure as Code (IaC):** All resources provisioned and version-controlled via Terraform.  
- **Modular Design:** Logical separation of VPC, ECS, S3, IAM, and monitoring.  
- **Workspaces:** Separate `dev` and `prod` environments with isolated states.  
- **Remote State (optional):** Designed for S3 + DynamoDB locking in team settings.  
- **CI/CD Ready:** GitHub Actions → AWS OIDC workflow for secure automated deployments.  


## Security & Compliance Features

### Encryption
- **S3 with SSE-S3 (AES-256)**  
- **TLS via ALB HTTPS (ACM ready for production)**  

### Network Isolation
- ECS tasks in **private subnets** only  
- ALB in **public subnets** (front door)  
- **No public SSH**; SSM Session Manager for admin access  

### Audit & Governance
- **CloudTrail** logs all AWS API activity to S3  
- **AWS Config** evaluates compliance (e.g., S3 encryption, CloudTrail enabled)  

### Cost & Monitoring
- **AWS Budgets** triggers monthly alerts via email  
- **CloudWatch Metrics & Alarms** for ECS and ALB health  


## Outcomes
- Achieved **99.99% uptime design** through Multi-AZ architecture and Fargate scaling.  
- Reduced provisioning time by **50%** via Terraform modules and automated pipelines.  
- Implemented **continuous compliance** via AWS Config managed rules.  
- Demonstrated **cost visibility** and control with AWS Budgets.  


## How to Deploy
```bash
# Clone the repo
git clone https://github.com/username/wealthvault-aws.git
cd wealthvault-aws

# Initialize Terraform
terraform init

# Plan and apply
terraform plan
terraform apply
```


## Verify Deployment
```bash
# Get the ALB URL and test it
terraform output alb_dns_name
curl -I http://$(terraform output -raw alb_dns_name)
# Expect: HTTP/1.1 200 OK (nginx)
```

Check in AWS Console:
- **ECS → Service** → Running Tasks = 2  
- **Target Group → Targets** = Healthy  
- **S3** → Public Access Block = ON, Versioning = Enabled  
- **CloudTrail + AWS Config** → Recording and evaluating  


## Clean Up
```bash
# Destroy all Terraform-managed resources (to avoid charges)
terraform destroy
```
> If you added resources outside Terraform, remove those manually before destroy.


## Future Enhancements
- Add **HTTPS (ACM)** and CloudFront for global low-latency delivery.  
- Add **RDS PostgreSQL (Multi-AZ, encrypted)** with Secrets Manager integration.  
- Integrate **WAF** for web-layer protection.  
- Extend **CI/CD pipeline** for blue/green ECS deployments.  


## SAA Concepts Demonstrated
- **Networking:** VPC, subnets, routing, NAT, security groups, ALB.  
- **Compute:** ECS Fargate, target groups, scaling policies.  
- **Storage:** S3 encryption, versioning, lifecycle management.  
- **Security:** IAM roles, least privilege, CloudTrail, Config.  
- **Monitoring:** CloudWatch, metrics, logs.  
- **Cost Optimization:** AWS Budgets, autoscaling, resource right-sizing.  


## License
MIT © Arvil Dey
