output "user_pool_id" {
  value = aws_cognito_user_pool.main_user_pool.id
}

output "client_pool_id" {
  value = aws_cognito_user_pool_client.user_pool_client.id
}

output "client_pool_secret" {
  value = aws_cognito_user_pool_client.user_pool_client.client_secret
}
