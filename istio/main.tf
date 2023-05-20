terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.20.0"
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
