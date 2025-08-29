terraform {
  required_version = ">= 1.6.0"
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "0.9.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.38.0"
    }
  }
}

provider "kind" {}

provider "helm" {
  kubernetes = {
    config_path = module.kind.kubeconfig_path
  }
}

provider "kubernetes" {
  config_path = module.kind.kubeconfig_path
}