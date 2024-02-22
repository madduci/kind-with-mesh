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

      # Expose Port 9879 (Cilium)
      extra_port_mappings {
        container_port = 30003
        host_port      = 9879
        protocol       = "TCP"
      }
    }

    node {
      role = "worker"
    }

    containerd_config_patches = [
      <<-YAML
      networking.disableDefaultCNI = true
      YAML
    ]
  }
}

module "istio" {
  source = "./istio-mesh"
  count = var.enable_istio ? 1 : 0
  kubeconfig = kind_cluster.local_cluster.kubeconfig
}

module "cilium" {
  source = "./cilium-mesh"
  count = var.enable_cilium ? 1 : 0
  kubeconfig = kind_cluster.local_cluster.kubeconfig
}