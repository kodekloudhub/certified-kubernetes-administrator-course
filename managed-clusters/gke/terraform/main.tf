terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = "us-west1"
}

resource "google_container_cluster" "primary" {
  name     = "kodekloud-demo-cluster"
  location = "us-west1"

  initial_node_count  = 1 # Number of nodes per zone
  deletion_protection = false
  
  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 20
    disk_type    = "pd-standard"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  networking_mode = "VPC_NATIVE"
}

variable "project_id" {
  description = "The Google Cloud project ID"
  type        = string
}
