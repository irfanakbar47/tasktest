terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.0.0"  # Specify the latest stable version you wish to use
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"  # Adjust based on your needs
    }
  }
  required_version = ">= 1.0"  
}
 
provider "aws" {
  region  = "eu-north-1"  
  profile = "default"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"  # Ensure it points to your kubeconfig file
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"  # Same here for Kubernetes provider
}