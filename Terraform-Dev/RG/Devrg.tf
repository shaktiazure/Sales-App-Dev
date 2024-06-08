terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.101.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "devRG"
    storage_account_name = "sdevstorage"
    container_name       = "sdevContainer"
    # key                  = "terraform.tfstate"
  }

}

provider "azurerm" {
  # Configuration options
  features {

  }

}



resource "azurerm_resource_group" "devRG" {
  name     = "Sales-Dev-RG"
  location = "West Europe"
}

