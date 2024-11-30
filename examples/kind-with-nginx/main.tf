module "kind" {
  source               = "../../modules/kind-cluster"
  cluster_name         = "local-cluster"
  worker_nodes         = 2
  kubeconfig_save_path = "./kubeconfig"
}

module "nginx_ingress" {
  source     = "../../modules/nginx-ingress"
  depends_on = [module.kind.kubeconfig_path]
}
