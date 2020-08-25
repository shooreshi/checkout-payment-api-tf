provider "azurerm" {
  version         = "~>2.0"
  features {}
  subscription_id = var.sub
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  skip_provider_registration = true
}

resource "azurerm_resource_group" "payment-api" {
    name = "payment-api-rg"
    location = "uksouth"
}

resource "azurerm_kubernetes_cluster" "payment-api" {
  name                = "payment-api-aks1"
  location            = azurerm_resource_group.payment-api.location
  resource_group_name = azurerm_resource_group.payment-api.name
  dns_prefix          = "paymentapiaks1"

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
  name                  = "payment-api-cluster"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.payment-api.id
  vm_size               = "Standard_DS2_v2"
  node_count            = 1

  tags = {
    Environment = "Production"
  }
}
