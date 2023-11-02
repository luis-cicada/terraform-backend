# Create Cognito User Pool
resource "aws_cognito_user_pool" "main_user_pool" {
  name                     = "${var.project_name}-user-pool-${var.stage}"
  auto_verified_attributes = ["email"]
  alias_attributes         = ["preferred_username", "email"]

  username_configuration {
    case_sensitive = true
  }

  password_policy {
    minimum_length    = 12
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  software_token_mfa_configuration {
    enabled = true
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }

    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 2
    }
  }

  mfa_configuration = "ON"

  schema {
    name                = "email"
    attribute_data_type = "String"
    mutable             = true
    required            = true
  }
  schema {
    name                = "phone_number"
    attribute_data_type = "String"
    mutable             = true
    required            = true
  }
  schema {
    name                = "preferred_username"
    attribute_data_type = "String"
    mutable             = true
    required            = true
  }
  schema {
    name                = "given_name"
    attribute_data_type = "String"
    mutable             = true
    required            = true
  }
  schema {
    name                = "middle_name"
    attribute_data_type = "String"
    mutable             = true
    required            = true
  }
  schema {
    name                = "family_name"
    attribute_data_type = "String"
    mutable             = true
    required            = true
  }
}

# Crate Cognito User Pool Client
resource "aws_cognito_user_pool_client" "user_pool_client" {
  depends_on = [aws_cognito_user_pool.main_user_pool]

  name = "${var.project_name}-user-pool-client-${var.stage}"

  user_pool_id = aws_cognito_user_pool.main_user_pool.id

  generate_secret     = true
  explicit_auth_flows = ["ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_PASSWORD_AUTH"]
}

