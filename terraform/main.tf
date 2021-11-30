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
  location = "southindia"
}

data "azurerm_container_registry" "acr" {
  name                = "kubenodejsacr"
  resource_group_name = "acrrg"
}


resource "azurerm_kubernetes_cluster" "lab3_aks" {
  name                = "lab3_aks"
  location            = azurerm_resource_group.lab3kuberg.location
  resource_group_name = azurerm_resource_group.lab3kuberg.name
  dns_prefix          = "labaks"

  default_node_pool {
    name       = "lab3aksnode"
    node_count = 4
    vm_size    = "Standard_DS1_v2"
    enable_auto_scaling = false
  }

  identity {
    type = "SystemAssigned"
  }
}

data "azurerm_user_assigned_identity" "aksmi" {
  name                = "${azurerm_kubernetes_cluster.lab3_aks.name}-agentpool"
  resource_group_name = "MC_${azurerm_resource_group.lab3kuberg.name}_${azurerm_kubernetes_cluster.lab3_aks.name}_${azurerm_resource_group.lab3kuberg.location}"
}

resource "azurerm_role_assignment" "role_Contributor" {
  scope                            = data.azurerm_container_registry.acr.id
  role_definition_name             = "Contributor"
  principal_id                     = data.azurerm_user_assigned_identity.aksmi.principal_id
  skip_service_principal_aad_check = true
}