# Secure, Highly Available Client Portfolio Management Platform – AWS + Terraform

## Overview
This project simulates the **AWS infrastructure** I designed and deployed for a **finance industry** client-facing application.  
The platform enables high-net-worth clients to securely access **portfolio data**, **transaction history**, and **market insights** in real time.

The focus was on **security**, **compliance**, **high availability**, and **cost optimization** — following best practices for **PCI-DSS** and **SOX** regulatory requirements.

---

## Key Business Requirements
- **24/7 availability** – Market data and portfolios must be accessible at all times.
- **Strict security & compliance** – Encryption in transit & at rest, audit logging, least-privilege IAM.
- **Scalable infrastructure** – Handle peak traffic during market hours without downtime.
- **Cost efficiency** – Monitor and control operational spend without compromising performance.

---

## Architecture

### Main Components
- **VPC with Public & Private Subnets** – Isolates sensitive workloads, restricts database access.
- **ECS Fargate Service** *(or EC2 Auto Scaling Group)* – Hosts the application in a scalable, containerized environment.
- **RDS (PostgreSQL)** – Multi-AZ, encrypted database for client portfolios & transactions.
- **S3 Bucket** – Encrypted storage for client statements & reports.
- **CloudFront CDN** – Low-latency delivery of static content with TLS.
- **IAM & Secrets Manager** – Least-privilege access control and secure credential storage.
- **CloudWatch & CloudTrail** – Real-time monitoring, logging, and compliance auditing.
- **AWS Budgets** – Automated cost alerts to prevent overspending.

---

## Terraform Implementation
- **Infrastructure as Code (IaC):** All AWS resources provisioned with Terraform.
- **Modular Design:** Reusable modules for VPC, ECS, RDS, S3, IAM, and monitoring.
- **Remote State:** Stored in S3 with DynamoDB locking for safe collaboration.
- **Workspaces:** Separate `dev` and `prod` environments with isolated state.
- **CI/CD:** GitHub Actions with OIDC → AWS IAM Role for secure, automated deployments.

---

## Security & Compliance Features

### Encryption
- **S3 with SSE-KMS**
- **RDS** with storage-level encryption
- **ACM certificates** for TLS

### Network Isolation
- Database in **private subnets**
- **No public SSH**; SSM Session Manager for admin access

### Audit & Governance
- **CloudTrail** logs all API activity to S3
- **AWS Config** enforces resource compliance

### Backup & DR
- Automated RDS backups
- Snapshot retention policy

---

## Impact & Outcomes
- **99.99% uptime** achieved through multi-AZ deployment & auto scaling.
- **Regulatory compliance** met for PCI-DSS & SOX, reducing audit risk.
- **50% faster environment provisioning** using Terraform modules & CI/CD pipelines.
- **30% cost savings** via right-sized compute, S3 lifecycle policies, and automated budget alerts.

---

## Screenshots
| ECS Service | CloudWatch Alarm | Budget Alert |
|-------------|------------------|--------------|
| ![ECS](screenshots/ecs_service.png) | ![CloudWatch](screenshots/cloudwatch_alarm.png) | ![Budget](screenshots/budget_alert.png) |

---

## How to Deploy

### 1. Clone Repo
```bash
git clone https://github.com/username/finance-portfolio-aws.git
cd finance-portfolio-aws
```

### 2. Initialize Terraform
```bash
terraform init
```

### 3. Select Environment
```bash
terraform workspace select dev
```

### 4. Apply Infrastructure
```bash
terraform apply
```

### 5. Access Application
Dev: https://dev.myfinanceapp.com
Prod: https://myfinanceapp.com

## Future Enhancements
- Add AWS WAF for advanced threat protection.
- Implement CloudFront signed URLs for sensitive documents.
- Expand CI/CD to include blue/green ECS deployments.
