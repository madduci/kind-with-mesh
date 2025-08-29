variable "helm_version" {
  description = "The version of the nginx Ingress Controller Helm Chart to be installed"
  type        = string
  default     = "4.12.5"
  validation {
    condition     = can(regex("^[0-9]+.[0-9]+.[0-9]+$", var.helm_version))
    error_message = "The Helm version must be in the format x.y.z"
  }
}

variable "helm_repository" {
  type        = string
  description = "Helm Chart Repository URL"
  default     = "https://kubernetes.github.io/ingress-nginx"
  validation {
    condition     = can(regex("https://.*", var.helm_repository)) || can(regex("oci://.*", var.helm_repository))
    error_message = "The Helm Repository URL must start with https:// or oci://"
  }
}

variable "namespace" {
  description = "Namespace where to install the services"
  type        = string
  default     = "ingress-nginx"
}

variable "toleration_label" {
  type        = string
  default     = "node-role.kubernetes.io/control-plane"
  description = "Defines label to be used for toleration when deploying the Ingress Controller"
  validation {
    condition     = length(var.toleration_label) > 0
    error_message = "The toleration label must not be empty"
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
  description = "Defines the configuration of the ports to be used by the Ingress Controller"

  validation {
    condition     = contains(keys(var.port_configuration), "http") && contains(keys(var.port_configuration), "https")
    error_message = "The configuration must include 'http' and 'https' configurations"
  }

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
