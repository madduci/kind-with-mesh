variable "kubeconfig" {
  description = "Path to the Kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "namespace" {
  description = "Namespace where to install the services"
  type        = string
  default     = "kube-system"
}

variable "cilium_version" {
  description = "The version of the Cilium Helm Chart to be installed"
  type        = string
  default     = "1.14.3"
}

variable "helm_repository" {
  type        = string
  description = "Helm Chart Repository URL"
  default     = "https://helm.cilium.io/"
}

variable "status_port" {
  description = "Defines the node port to use with the local cluster (kind) for Status check"
  type = object({
    port       = number
    targetPort = number
    name       = string
    protocol   = string
    nodePort   = number
  })
  default = {
    name       = "status-port"
    protocol   = "TCP"
    port       = 9879
    targetPort = 9879
    nodePort   = 30003
  }
}

variable "insecure_port" {
  description = "Defines the node port to use with the local cluster (kind) for plain HTTP"
  type = object({
    port       = number
    targetPort = number
    name       = string
    protocol   = string
    nodePort   = number
  })
  default = {
    name       = "plain"
    protocol   = "TCP"
    port       = 80
    targetPort = 80
    nodePort   = 30000
  }
}

variable "secure_port" {
  description = "Defines the node port to use with the local cluster (kind) for TLS"
  type = object({
    port       = number
    targetPort = number
    name       = string
    protocol   = string
    nodePort   = number
  })
  default = {
    name       = "secure"
    protocol   = "TCP"
    port       = 443
    targetPort = 443
    nodePort   = 30001
  }
}
