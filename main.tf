terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.97.0"
    }
    akeyless = {
      version = ">= 1.0.0"
      source  = "akeyless-community/akeyless"
    }
  }
}

# variable "access_id" {
#   type        = string
#   description = "value of the Akeyless API access id (This Access ID MUST be configured in the allowedAccessIDs of the Gateway or BE the adminAccessId for the Gateway)"
# }

# variable "access_key" {
#   type        = string
#   description = "value of the Akeyless API access key"
#   sensitive   = true
# }

# variable "api_gateway_address" {
#   type        = string
#   description = <<-EOF
#     value of the Akeyless Gateway 8081 port address 
#     Examples:
#     - http://localhost:8081 if using port forwarding
#     - http://your-gateway-ip-address:8081 if using a port
#     - https://your-gateway-api-address.com that maps to the 8081 port
#     EOF
# }

provider "azurerm" {
  features {}
}

provider "akeyless" {
  api_gateway_address = var.api_gateway_address

  api_key_login {
    access_id  = var.access_id
    access_key = var.access_key
  }

  # aws_iam_login {
  #   access_id = var.access_id
  # }

  # azure_ad_login {
  #   access_id = var.access_id
  # }

  # email_login {
  #   admin_email    = ""
  #   admin_password = ""
  # }
}

