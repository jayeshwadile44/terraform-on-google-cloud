# Terraform Settings Block
terraform {
  required_version = "~> 1.16.2"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 8.2.0"
    }
  }
}

# Terraform Provider Block ( Heart of terraform)
provider "google" {
  project = "darkfiber-terraform" # PROJECT_ID
  region  = "us-central1"
  zone    = "us-central1-a"

  default_labels = {
    environment = "dev"
    cost-center = "dev-budget"
    managed_by  = "terraform"
  }
}

