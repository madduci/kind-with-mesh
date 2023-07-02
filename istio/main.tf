terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.10.1"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.21.1"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig
}

locals {
  target_namespace = kubernetes_namespace_v1.istio-system.metadata[0].name
}

resource "kubernetes_namespace_v1" "istio-system" {
  metadata {
    name = var.namespace
  }
}
