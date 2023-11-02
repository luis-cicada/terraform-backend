output "s3_lambda_storage_bucket_id" {
  value = aws_s3_bucket.lambda_storage.id
}

output "s3_app_file_storage_bucket_id" {
  value = aws_s3_bucket.app_file_storage.id
}