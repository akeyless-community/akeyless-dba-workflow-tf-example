terraform {
  required_providers {
    akeyless = {
      version = ">= 1.0.0"
      source  = "akeyless-community/akeyless"
    }
  }
}

variable "dyn_secret_config" {
}

resource "akeyless_producer_mongo" "mongo_producer" {
  name                    = var.dyn_secret_config.resourceName
  target_name             = var.dyn_secret_config.targetName
  mongodb_default_auth_db = "admin"
  user_ttl                = var.dyn_secret_config.user_ttl
  mongodb_roles = jsonencode(var.dyn_secret_config.mongodb_roles)
}

resource "akeyless_role" "k8s-access-role" {
  name = var.dyn_secret_config.roleName

  dynamic "assoc_auth_method" {
    for_each = var.dyn_secret_config.auth_methods

    content {
      am_name = assoc_auth_method.key
      sub_claims = assoc_auth_method.value.subClaims
    }
  }

  dynamic "rules" {
    for_each = var.dyn_secret_config.ruleList

    content {
      path = rules.key
      capability = rules.value.allowedCapabilities
      rule_type = rules.value.ruleType
    }
  }
}