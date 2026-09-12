module "cilium" {
  source     = "../../modules/cilium-mesh"

  port_configuration = var.port_configuration
}
