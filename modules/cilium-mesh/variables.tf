variable "helm_version" {
  description = "The version of the Cilium Helm Chart to be installed"
  type        = string
  default     = "1.18.5"
  validation {
    condition     = can(regex("^[0-9]+.[0-9]+.[0-9]+$", var.helm_version))
    error_message = "The Helm version must be in the format x.y.z"
  }
}

variable "helm_repository" {
  type        = string
  description = "Helm Chart Repository URL"
  default     = "https://helm.cilium.io/"
  validation {
    condition     = can(regex("https://.*", var.helm_repository)) || can(regex("oci://.*", var.helm_repository))
    error_message = "The Helm Repository URL must start with https:// or oci://"
  }
}

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
    cilium-port = {
      app_protocol = "http"
      node_port    = 30003
      host_port    = 9876
      target_port  = 9876
      protocol     = "TCP"
    }
  }
}
