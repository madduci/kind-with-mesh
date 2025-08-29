module "kind" {
  source               = "../../modules/kind-cluster"
  cluster_name         = "local-cluster-nginx"
  worker_nodes         = 1
  kubeconfig_save_path = "./kubeconfig"

  port_configuration = var.port_configuration
}

module "nginx_ingress" {
  source     = "../../modules/nginx-ingress"
  depends_on = [module.kind.kubeconfig_path]

  port_configuration = var.port_configuration
}
