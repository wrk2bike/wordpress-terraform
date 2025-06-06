# WordPress Three-Tier Architecture with Terraform

This project deploys a scalable WordPress CMS application using a three-tier architecture on AWS:

1. **Web Tier**: Application Load Balancer (ALB)
2. **Application Tier**: Auto Scaling Group with EC2 instances running WordPress
3. **Database Tier**: Amazon RDS MySQL instance

## Architecture Overview

- **Web Tier**: Public-facing ALB that distributes traffic to the application tier
- **Application Tier**: EC2 instances in private subnets running WordPress
- **Database Tier**: RDS MySQL instance in private subnets

## GitHub Actions Deployment

This project is configured to deploy via GitHub Actions. The workflow will:

1. Run on pushes to the main branch and pull requests
2. Plan changes on pull requests
3. Apply changes when merged to main

### Required GitHub Secrets

Set up the following secrets in your GitHub repository:

- `AWS_ACCESS_KEY_ID`: AWS access key with permissions to create resources
- `AWS_SECRET_ACCESS_KEY`: AWS secret key
- `AWS_REGION`: AWS region to deploy to (e.g., "us-east-1")
- `VPC_CIDR`: CIDR block for the VPC (e.g., "10.0.0.0/16")
- `DB_NAME`: Name for the WordPress database
- `DB_USERNAME`: Username for the database
- `DB_PASSWORD`: Password for the database
- `INSTANCE_TYPE`: EC2 instance type (e.g., "t3.small")
- `DB_INSTANCE_CLASS`: RDS instance class (e.g., "db.t3.small")
- `MIN_SIZE`: Minimum number of EC2 instances (e.g., 2)
- `MAX_SIZE`: Maximum number of EC2 instances (e.g., 4)
- `TF_STATE_BUCKET`: Name of your S3 bucket for Terraform state
- `TF_STATE_KEY`: Path to state file in the bucket (e.g., "wordpress/terraform.tfstate")
- `TF_LOCK_TABLE`: Name of your DynamoDB table for state locking

## Security Considerations for Public Repositories

This setup includes several security measures for public repositories:

1. All sensitive values are stored in GitHub Secrets
2. Backend configuration is parameterized using secrets
3. Workflow runs are restricted for pull requests from forks
4. S3 bucket names and other infrastructure details are not hardcoded

## Prerequisites

Before running the GitHub Actions workflow:

1. Create an S3 bucket for storing Terraform state
2. Create a DynamoDB table with a primary key of "LockID" for state locking
3. Run the "Setup Terraform Backend" workflow or use the setup script locally

## Local Development

For local development:

1. Clone this repository
2. Create a `terraform.tfvars` file with your configuration
3. Run `terraform init`, `terraform plan`, and `terraform apply`

## Cleanup

To destroy all resources:
```
terraform destroy
```