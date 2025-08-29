variable "port_configuration" {
  type = map(object({
    app_protocol = string
    node_port    = number
    host_port    = number
    target_port  = number
    protocol     = string
  }))
  description = "Defines the port mappings for the cluster nodes"

  default = {
    http = {
      app_protocol = "http"
      node_port    = 30000
      host_port    = 80
      target_port  = 80
      protocol     = "TCP"
    }
    https = {
      app_protocol = "https"
      node_port    = 30001
      host_port    = 443
      target_port  = 443
      protocol     = "TCP"
    }
  }
}
