provider "aws" {
  region  = var.aws_region
  profile = "terraform-user"
}


module "vpc" {
  source       = "../modules/vpc"
  aws_region   = var.aws_region
  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
}

module "s3" {
  source       = "../modules/s3"
  aws_region   = var.aws_region
  project_name = var.project_name
  stage        = var.stage
}