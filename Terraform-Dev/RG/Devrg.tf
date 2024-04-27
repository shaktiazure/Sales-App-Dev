terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.101.0"
    }
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

