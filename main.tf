provider "azurerm" {
  version         = "~>2.0"
  features {}
  subscription_id = var.sub
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  skip_provider_registration = true
}

data "azurerm_resource_group" "resourcegroup" {
  name = "payment-api-rg-paymentapiaks"
}

resource "azurerm_kubernetes_cluster" "payment-api" {
  name                = "paymentapiaks"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name
  dns_prefix          = "paymentapiaks"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "payment-api" {
  name                  = "paymentcstr"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.payment-api.id
  vm_size               = "Standard_DS2_v2"
  node_count            = 1

  tags = {
    Environment = "Production"
  }
}
