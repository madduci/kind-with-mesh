terraform {
  required_version = ">= 1.6.0"
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "0.10.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.1.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.0.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.4"
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