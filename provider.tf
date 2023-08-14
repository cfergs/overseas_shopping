terraform {
  required_version = "~> 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.67.0"
    }
    publicip = {
      source  = "nxt-engineering/publicip"
      version = ">=0.0.9"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=3.5.1"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
  skip_provider_registration = true
}

provider "publicip" {}
