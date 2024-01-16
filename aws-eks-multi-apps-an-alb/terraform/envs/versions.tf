terraform {
  required_providers {
    aws = {
      version = ">= 4.25.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.4.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.7.1"
    }

    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
}


