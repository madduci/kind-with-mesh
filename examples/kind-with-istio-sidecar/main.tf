module "istio" {
  source     = "../../modules/istio-mesh"

  port_configuration = var.port_configuration
}
