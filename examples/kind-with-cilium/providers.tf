terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "0.7.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.1"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.34.0"
    }
  }
}

provider "kind" {}

provider "helm" {
  kubernetes {
    config_path = module.kind.kubeconfig_path
  }
}

provider "kubernetes" {
  config_path = module.kind.kubeconfig_path
}