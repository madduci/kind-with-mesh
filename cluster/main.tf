terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "0.2.0"
    }
  }
}

provider "kind" {}

resource "kind_cluster" "local_cluster" {
  name           = var.cluster_name
  node_image     = "kindest/node:${var.kubernetes_version}"
  wait_for_ready = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"

      # Expose Port 80
      extra_port_mappings {
        container_port = 30000
        host_port      = 80
        protocol       = "TCP"
      }

      # Expose Port 443
      extra_port_mappings {
        container_port = 30001
        host_port      = 443
        protocol       = "TCP"
      }
      
      # Expose Port 15021 (Istio)
      extra_port_mappings {
        container_port = 30002
        host_port      = 15021
        protocol       = "TCP"
      }
    }

    node {
      role = "worker"
    }
  }
}
