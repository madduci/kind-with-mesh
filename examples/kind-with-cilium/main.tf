module "kind" {
  source               = "../../modules/kind-cluster"
  cluster_name         = "local-cluster-cilium"
  worker_nodes         = 2
  kubeconfig_save_path = "./kubeconfig"

  port_configuration = var.port_configuration
  # Use Cilium as CNI
  disable_default_cni = true
}

module "cilium" {
  source     = "../../modules/cilium-mesh"
  depends_on = [module.kind.kubeconfig_path]

  port_configuration = var.port_configuration
}
