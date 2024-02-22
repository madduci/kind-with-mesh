terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "0.4.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.12.1"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.26.0"
    }
  }
}

provider "kind" {}

provider "helm" {
  kubernetes {
    config_path = kind_cluster.local_cluster.kubeconfig_path
  }
}

provider "kubernetes" {
  config_path = kind_cluster.local_cluster.kubeconfig_path
}