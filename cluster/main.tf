resource "kind_cluster" "local_cluster" {
  name            = var.cluster_name
  node_image      = "kindest/node:${var.kubernetes_version}"
  wait_for_ready  = true
  kubeconfig_path = var.kubeconfig_save_path

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"

      # Apply patch for Ingress 
      kubeadm_config_patches = [<<-YAML
        kind: InitConfiguration
        nodeRegistration:
          kubeletExtraArgs:
            node-labels: "ingress-ready=true"
        YAML 
      ]

      # Expose Port 80
      extra_port_mappings {
        container_port = 80
        host_port      = 80
        protocol       = "TCP"
      }

      # Expose Port 443
      extra_port_mappings {
        container_port = 443
        host_port      = 443
        protocol       = "TCP"
      }

      # Expose Port 15021 (For istioctl)
      extra_port_mappings {
        container_port = 15021
        host_port      = 15021
        protocol       = "TCP"
      }

      # Expose Port 9879 (For Cilium CLI)
      extra_port_mappings {
        container_port = 9879
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
  source     = "./istio-mesh"
  count      = var.enable_istio ? 1 : 0
  depends_on = [kind_cluster.local_cluster]
}

module "cilium" {
  source     = "./cilium-mesh"
  count      = var.enable_cilium ? 1 : 0
  depends_on = [kind_cluster.local_cluster]
}

module "nginx_ingress" {
  source = "./nginx-ingress"
  # enable ingress-nginx only if Cilium and Istio are not installed
  count      = var.enable_istio == false && var.enable_cilium == false ? 1 : 0
  depends_on = [kind_cluster.local_cluster]
}