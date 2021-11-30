provider "azurerm" {
  features {}

}

resource "azurerm_resource_group" "project2_rg" {
  name     = "__resourcegroupname__"
  location = "__location__"
}

data "azurerm_container_registry" "acr" {
  name                = "__acrname__"
  resource_group_name = "test"
}


resource "azurerm_kubernetes_cluster" "wolkweb_aks" {
  name                = "__akscluster__"
  location            = azurerm_resource_group.project2_rg.location
  resource_group_name = azurerm_resource_group.project2_rg.name
  dns_prefix          = "wolkwebaks"

  default_node_pool {
    name       = "wolknodepl"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
    enable_auto_scaling = false
  }

  identity {
    type = "SystemAssigned"
  }
}

data "azurerm_user_assigned_identity" "aksmi" {
  name                = "${azurerm_kubernetes_cluster.wolkweb_aks.name}-agentpool"
  resource_group_name = "MC_${azurerm_resource_group.project2_rg.name}_${azurerm_kubernetes_cluster.wolkweb_aks.name}_${azurerm_resource_group.project2_rg.location}"
}

resource "azurerm_role_assignment" "role_Contributor" {
  scope                            = data.azurerm_container_registry.acr.id
  role_definition_name             = "Contributor"
  principal_id                     = data.azurerm_user_assigned_identity.aksmi.principal_id
  skip_service_principal_aad_check = true
}