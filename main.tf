provider "azurerm" {
  features {}

}

terraform {
    backend "azurerm" {
        resource_group_name = "terraformrg"
        storage_account_name = "terraformstorageaccoun"
        container_name = "terraform"
        key = "terraform.tfstate"
    }
}

resource "azurerm_resource_group" "lab3kuberg" {
  name     = "lab3kuberg"
  location = "eastus"
}




resource "azurerm_kubernetes_cluster" "lab3_aks" {
  name                = "lab3_aks"
  location            = azurerm_resource_group.lab3kuberg.location
  resource_group_name = azurerm_resource_group.lab3kuberg.name
  dns_prefix          = "labaks"

  default_node_pool {
    name       = "lab3aksnode"
    node_count = 4
    vm_size    = "Standard_DS2_v2"
    enable_auto_scaling = false
  }

  identity {
    type = "SystemAssigned"
  }
}

