#!/bin/bash

# This script creates the S3 bucket and DynamoDB table for Terraform remote state
# One-time setup, before running Terraform

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install it before running this script."
    exit 1
fi

# Set variables
REGION="${1:-us-east-1}"  # Default to us-east-1 if not provided
BUCKET_NAME="${2:-terraform-state-$(date +%s)}"  # Use timestamp for unique name if not provided
TABLE_NAME="${3:-terraform-locks-$(date +%s)}"  # Use timestamp for unique name if not provided

echo "Creating S3 bucket for Terraform state..."
aws s3api create-bucket \
    --bucket $BUCKET_NAME \
    --region $REGION \
    --create-bucket-configuration LocationConstraint=$REGION

# Enable versioning on the S3 bucket
aws s3api put-bucket-versioning \
    --bucket $BUCKET_NAME \
    --versioning-configuration Status=Enabled

# Enable encryption on the S3 bucket
aws s3api put-bucket-encryption \
    --bucket $BUCKET_NAME \
    --server-side-encryption-configuration '{
        "Rules": [
            {
                "ApplyServerSideEncryptionByDefault": {
                    "SSEAlgorithm": "AES256"
                }
            }
        ]
    }'

# Block public access to the S3 bucket
aws s3api put-public-access-block \
    --bucket $BUCKET_NAME \
    --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

echo "Creating DynamoDB table for Terraform locks..."
aws dynamodb create-table \
    --table-name $TABLE_NAME \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region $REGION

echo "Terraform backend infrastructure setup complete!"
echo "S3 Bucket: $BUCKET_NAME"
echo "DynamoDB Table: $TABLE_NAME"
echo "Region: $REGION"
echo ""
echo "Add these values to your GitHub repository secrets:"
echo "TF_STATE_BUCKET: $BUCKET_NAME"
echo "TF_STATE_KEY: terraform.tfstate"
echo "TF_LOCK_TABLE: $TABLE_NAME"