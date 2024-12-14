module "kind" {
  source               = "../../modules/kind-cluster"
  cluster_name         = "local-cluster"
  worker_nodes         = 2
  kubeconfig_save_path = "./kubeconfig"
}

module "istio" {
  source     = "../../modules/istio-mesh"
  depends_on = [module.kind.kubeconfig_path]
}
