# Terraform Settings Block
terraform {
  required_version = "~> 1.16.2"
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 8.2.0"
    }
  }
}

# Terraform Provider-1: us-central1
provider "google" {
  project = "darkfiber-terraform" #project ID
  region = "us-central1"
  alias = "provider_Prod_us-central1"    
}

# Terraform Provider-2: europe-west1
provider "google" {
  project = "darkfiber-terraform"
  region = "europe-west1"
  alias = "provider_dev_europe-west1"    
}