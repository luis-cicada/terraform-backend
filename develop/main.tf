provider "aws" {
  region  = var.aws_region
  profile = "terraform-user"
}

# Crate VPC Modules
module "vpc" {
  source       = "../modules/vpc"
  aws_region   = var.aws_region
  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
}

# Create S3 Buckets
module "s3" {
  source       = "../modules/s3"
  aws_region   = var.aws_region
  project_name = var.project_name
  stage        = var.stage
}

# Create Cognito User Pool and Client
module "cognito" {
  source       = "../modules/cognito"
  project_name = var.project_name
  stage        = var.stage
}