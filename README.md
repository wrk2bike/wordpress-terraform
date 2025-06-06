# WordPress Three-Tier Architecture with Terraform

This project deploys a scalable WordPress CMS application using a three-tier architecture on AWS:

1. **Web Tier**: Application Load Balancer (ALB)
2. **Application Tier**: Auto Scaling Group with EC2 instances running WordPress
3. **Database Tier**: Amazon RDS MySQL instance

## Architecture Overview

![Three-Tier Architecture](https://d1.awsstatic.com/architecture-diagrams/ArchitectureDiagrams/three-tier-web-architecture.pdf?did=wp_card&trk=wp_card)

- **Web Tier**: Public-facing ALB that distributes traffic to the application tier
- **Application Tier**: EC2 instances in private subnets running WordPress
- **Database Tier**: RDS MySQL instance in private subnets

## Prerequisites

- AWS account with appropriate permissions
- Terraform installed (version 1.0.0 or later)
- AWS CLI configured with access credentials

## Deployment Instructions

1. Clone this repository
2. Create a `terraform.tfvars` file based on the example:
   ```
   cp terraform.tfvars.example terraform.tfvars
   ```
3. Edit `terraform.tfvars` with your desired configuration
4. Initialize Terraform:
   ```
   terraform init
   ```
5. Review the deployment plan:
   ```
   terraform plan
   ```
6. Apply the configuration:
   ```
   terraform apply
   ```
7. After deployment, access WordPress using the URL from the output:
   ```
   terraform output wordpress_url
   ```

## Security Considerations

- Database credentials are stored as sensitive variables
- Private subnets are used for application and database tiers
- Security groups restrict access between tiers
- NAT Gateway provides outbound internet access for private subnets

## Customization

- Adjust instance types in `terraform.tfvars` for different workloads
- Modify Auto Scaling parameters for different traffic patterns
- Update AMI ID for different regions or OS requirements

## Cleanup

To destroy all resources created by this project:
```
terraform destroy
```