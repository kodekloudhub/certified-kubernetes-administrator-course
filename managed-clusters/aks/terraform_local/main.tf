terraform {
  required_version = ">= 1.7.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.26.0"
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


# For KodeKloud Connections - Starting

# If running on Linux, MacOS or Git Bash on Windows, use the below block , else comment this section. 
#data "external" "environment" {
#  program = ["bash", "${path.module}/environment.sh"]
#}

# If running on Powershell on Windows, use the below block , else comment this section. 
 data "external" "environment" {
   program = ["powershell", "-ExecutionPolicy", "Bypass", "-File", "${path.module}/environment.ps1"]
 }


locals {
  subscription_id     = var.ARM_SUBSCRIPTION_ID
  location            = data.external.environment.result["location"]
  resource_group_name = data.external.environment.result["resource_group_name"]
}

output "subscription_id" {
  value = local.subscription_id
}

output "resource_group_name" {
  value = local.resource_group_name
}

output "location" {
  value = local.location
}

# For KodeKloud Connections - Ending

variable "ARM_CLIENT_ID" {
  type        = string
  description = "Azure Client ID"
}

variable "ARM_CLIENT_SECRET" {
  type        = string
  description = "Azure Client Secret"
}

variable "ARM_TENANT_ID" {
  type        = string
  description = "Azure Tenant ID"
}

variable "ARM_SUBSCRIPTION_ID" {
  type        = string
  description = "Azure Subscription ID"
}

# Configure Azure provider
provider "azurerm" {
  resource_provider_registrations = "none"
  features {}
  client_id       = var.ARM_CLIENT_ID
  client_secret   = var.ARM_CLIENT_SECRET
  tenant_id       = var.ARM_TENANT_ID
  subscription_id = var.ARM_SUBSCRIPTION_ID
}

# Generate a random suffix for cluster's DNS prefix
resource "random_string" "dns" {
  length  = 6
  upper   = false
  lower   = false
  numeric = true
  special = false
}

# Deploy the cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = local.location
  resource_group_name = local.resource_group_name

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
              upgrade_settings {
               drain_timeout_in_minutes      = "0"
               max_surge                     = "10%"
               node_soak_duration_in_minutes = "0"
            }
  }
}

# Output the AZ commands user needs to run in order to access cluster.
output "commands" {
    value = join("\n", [
        "",
        "Now run the following commands to gain kubectl access to the cluster",
        "",
        "az account set --subscription ${local.subscription_id}",
        "az aks get-credentials --resource-group ${local.resource_group_name} --name ${var.cluster_name} --overwrite-existing",
        ""
    ])
}
