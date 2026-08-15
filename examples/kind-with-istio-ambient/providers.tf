terraform {
  required_version = ">= 1.8.0"

  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "0.11.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.2.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.3.1"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "4.5.0"
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

provider "docker" {
  host = "unix:///var/run/docker.sock"
}