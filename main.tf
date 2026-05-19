# Generate random resource group name
resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
}

resource "random_pet" "azurerm_kubernetes_cluster_name" {
  prefix = "cluster"
}

resource "random_pet" "azurerm_kubernetes_cluster_dns_prefix" {
  prefix = "dns"
}

resource "azurerm_kubernetes_cluster" "k8s" {
  location            = azurerm_resource_group.rg.location
  name                = random_pet.azurerm_kubernetes_cluster_name.id
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = random_pet.azurerm_kubernetes_cluster_dns_prefix.id

  sku_tier = "Free"

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name = "agentpool"

    # VM bem mais barata
    vm_size = "Standard_B2s"

    # Apenas 1 node para laboratório
    node_count = 1

    # Disco mais barato
    os_disk_type    = "Managed"
    os_disk_size_gb = 30

    # Opcional
    enable_auto_scaling = false
  }

  linux_profile {
    admin_username = var.username

    ssh_key {
      key_data = azapi_resource_action.ssh_public_key_gen.output.publicKey
    }
  }

  network_profile {

    # Mais moderno e econômico
    network_plugin = "azure"
    network_plugin_mode = "overlay"

    # Mantém compatibilidade
    load_balancer_sku = "standard"
  }

  tags = {
    environment = "lab"
    owner       = "carlos"
    cost        = "low"
  }
}
