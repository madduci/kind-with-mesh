module "istio" {
  source     = "../../modules/istio-mesh"
  depends_on = [docker_container.cloud_controller_manager]

  port_configuration  = var.port_configuration
  enable_ambient_mode = true
}
