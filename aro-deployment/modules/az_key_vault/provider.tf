terraform {
  required_providers {
    azapi = {
      source = "Azure/azapi"
      version = "~> 1"
    }

    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 3"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_deleted_secrets_on_destroy = true
      recover_soft_deleted_secrets          = true
    }
  }
}