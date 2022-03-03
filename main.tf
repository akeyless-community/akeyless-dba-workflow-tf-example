terraform {
  required_providers {
    akeyless = {
      version = ">= 1.0.0"
      source  = "akeyless-community/akeyless"
    }
  }
  backend "gcs" {
    bucket = "akeyless-cg-tf"
    prefix = "dba-example"
  }
}

variable "access_id" {
  type        = string
  description = "value of the Akeyless API access id (This Access ID MUST be configured in the allowedAccessIDs of the Gateway or BE the adminAccessId for the Gateway)"
}

variable "access_key" {
  type        = string
  description = "value of the Akeyless API access key"
  sensitive   = true
}

variable "api_gateway_address" {
  type        = string
  description = <<-EOF
    value of the Akeyless Gateway 8081 port address 
    Examples:
    - http://localhost:8081 if using port forwarding
    - http://your-gateway-ip-address:8081 if using a port
    - https://your-gateway-api-address.com that maps to the 8081 port
    EOF
}

provider "akeyless" {
  api_gateway_address = var.api_gateway_address

  api_key_login {
    access_id  = var.access_id
    access_key = var.access_key
  }
}

module "mongodb_atlas_producer" {
  source = "./producer"
  dyn_secret_config = {
    # The name of the dynamic secret
    resourceName = "/Azure MongoDB Atlas - Sample Analytics"
    # The name of the target database that the dynamic secret will be applied to
    targetName = "/Azure Atlas"
    # The time to live for the temporary credentials produced by the dynamic secret
    user_ttl = "8h"
    # The roles that the dynamic secret will have access to
    mongodb_roles = [
      {
        roleName     = "readWrite",
        databaseName = "sample_analytics"
      }
    ]
    # The name of the role that will grant the team access to the resource
    roleName = "/terraform-db/Team1"
    auth_methods = {
      # The key is the full path to the kubernetes auth method
      "/my-k8s-auth-method" = {
        subClaims = {
          namespace = "team1"
        }
      }
      # The key is the full path to the SAML provider so the team members can access the secret
      "/OktaSAML" = {
        subClaims = {
          groups = "Team1"
        }
      }
    }
    ruleList = {
      # The key is the access path to the secret object
      "/k8s/*" = {
        # What permissions do you want the team to have
        allowedCapabilities = ["read", "list"]
        # The type of rule (eg. item-rule, target-rule, role-rule, auth-method-rule)
        ruleType = "item-rule"
      }
      # The key is the access path to the secret object
      "/Azure MongoDB Atlas - Sample Analytics" = {
        # What permissions do you want the team to have
        allowedCapabilities = ["read", "list"]
        # The type of rule (eg. item-rule, target-rule, role-rule, auth-method-rule)
        ruleType = "item-rule"
      }
    }
  }
}

module "mongodb_atlas_producer2" {
  source = "./producer"
  dyn_secret_config = {
    # The name of the dynamic secret
    resourceName = "/Azure MongoDB Atlas - Sample Restaurants"
    # The name of the target database that the dynamic secret will be applied to
    targetName = "/Azure Atlas"
    # The time to live for the temporary credentials produced by the dynamic secret
    user_ttl = "8h"
    # The roles that the dynamic secret will have access to
    mongodb_roles = [
      {
        roleName     = "readWrite",
        databaseName = "sample_restaurants"
      }
    ]
    # The name of the role that will grant the team access to the resource
    roleName = "/terraform-db/Team2"
    auth_methods = {
      # The key is the full path to the kubernetes auth method
      "/my-k8s-auth-method" = {
        subClaims = {
          namespace = "team2"
        }
      }
      # The key is the full path to the SAML provider so the team members can access the secret
      "/OktaSAML" = {
        subClaims = {
          groups = "Team2"
        }
      }
    }
    ruleList = {
      # The key is the access path to the secret object
      "/k8s/*" = {
        # What permissions do you want the team to have
        allowedCapabilities = ["read", "list"]
        # The type of rule (eg. item-rule, target-rule, role-rule, auth-method-rule)
        ruleType = "item-rule"
      }
      # The key is the access path to the secret object
      "/Azure MongoDB Atlas - Sample Restaurants" = {
        # What permissions do you want the team to have
        allowedCapabilities = ["read", "list"]
        # The type of rule (eg. item-rule, target-rule, role-rule, auth-method-rule)
        ruleType = "item-rule"
      }
    }
  }
}