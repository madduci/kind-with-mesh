variable "helm_version" {
  description = "The version of the nginx Ingress Controller Helm Chart to be installed"
  type        = string
  default     = "4.12.1"
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

variable "local_node_ports" {
  description = "Defines the node ports to use with the local cluster (kind)"
  type = list(object({
    app_protocol = string
    name         = string
    target_port  = string
    protocol     = string
    port         = number
    node_port    = number
  }))
  default = [
    {
      app_protocol = "http"
      name         = "http"
      target_port  = "http"
      protocol     = "TCP"
      port         = 80
      node_port    = 30000
    },
    {
      app_protocol = "https"
      name         = "https"
      target_port  = "https"
      protocol     = "TCP"
      port         = 443
      node_port    = 30001
  }]
}
