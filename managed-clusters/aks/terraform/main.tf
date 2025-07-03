terraform {
  required_version = ">= 1.7.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    external = {
      source = "hashicorp/external"
      version = "~> 2.3"
    }
  }
}

variable "cluster_name" {
    type = string
    default = "kodekloud-demo"
}

data "external" "environment" {
  program = ["${path.module}/environment.sh"]
}

provider "azurerm" {
  subscription_id = data.external.environment.result["subscription_id"]
  resource_provider_registrations = "none"
  features {}
}

resource "random_string" "dns" {
  length  = 6
  upper   = false
  lower   = false
  numeric = true
  special = false
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = data.external.environment.result["location"]
  resource_group_name = data.external.environment.result["resource_group_name"]

  # Preset: Dev/Test –> control‑plane tier Free
  sku_tier = "Free"

  # RBAC with local accounts (the portal default)
  role_based_access_control_enabled = true
  local_account_disabled            = false

  # System‑assigned managed identity for the cluster
  identity {
    type = "SystemAssigned"
  }

  dns_prefix = "${var.cluster_name}-${random_string.dns.result}"

  ############################################
  # Default system node‑pool (manual scaling) #
  ############################################
  default_node_pool {
    name               = "sysnp"          # 3–12 chars, starts with letter
    vm_size            = "Standard_D2s_v3"
    node_count         = 2                # manual scaling, fixed at 2
    os_sku             = "Ubuntu"
  }

  ################################################
  # Networking – leave profile blank for kubenet #
  ################################################

}

output "commands" {
    value = join("\n", [
        "",
        "Now run the following commands to gain kubectl access to the cluster",
        "",
        "az account set --subscription ${data.external.environment.result["subscription_id"]}",
        "az aks get-credentials --resource-group ${data.external.environment.result["resource_group_name"]} --name ${var.cluster_name} --overwrite-existing"
    ])
}

#  174  az account set --subscription $ACC_USER_SUBSCRIPTION
#  175  az aks get-credentials --resource-group kml_rg_main-17d414714c8d4cf0 --name kodekloud-demo --overwrite-existing
