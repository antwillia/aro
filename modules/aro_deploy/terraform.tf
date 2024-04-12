terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>2.43"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.92.0"
    }
    azapi = {
      source = "Azure/azapi"
      version = "~> 1"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_deleted_secrets_on_destroy = true
      recover_soft_deleted_secrets          = true
    }
  }
  skip_provider_registration = true
}
