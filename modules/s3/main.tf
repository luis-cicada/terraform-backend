
# Creating S3 buckets for the project lambda storage
resource "aws_s3_bucket" "lambda_storage" {
  bucket = "com.${var.project_name}.${var.aws_region}.${var.stage}.deploys"

  tags = {
    Name = "${var.project_name}-lambda-storage"
    Environment = var.stage
  }
}

# Creating S3 buckets for the project app file storage
resource "aws_s3_bucket" "app_file_storage" {
  bucket = "${var.project_name}-documents-${var.stage}"

    tags = {
        Name = "${var.project_name}-app-file-storage"
        Environment = var.stage
    }
}

# Adding versioning to the app file storage bucket
resource "aws_s3_bucket_versioning" "app_file_versioning" {
  bucket = aws_s3_bucket.app_file_storage.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Adding lifecycle rules to the app file storage bucket
resource "aws_s3_bucket_lifecycle_configuration" "app_file_lifecycle" {
  bucket = aws_s3_bucket.app_file_storage.id

  rule {
    id = "app_file_storage_lifecycle_rule"
    status = "Enabled"

    transition {
      days = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days = 90
      storage_class = "GLACIER"
    }
  }
}