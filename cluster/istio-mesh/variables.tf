variable "local_node_ports_istio" {
  description = "Defines the node ports to use with the local cluster (kind)"
  type = list(object({
    port       = number
    targetPort = number
    name       = string
    protocol   = string
    nodePort   = string
  }))
  default = [{
    name       = "status-port"
    protocol   = "TCP"
    port       = 15021
    targetPort = 15021
    nodePort   = 30002 # same port as in ../main.tf
    },
    {
      name       = "http2"
      protocol   = "TCP"
      port       = 80
      targetPort = 80
      nodePort   = 30000 # same port as in ../main.tf
    },
    {
      name       = "https"
      protocol   = "TCP"
      port       = 443
      targetPort = 443
      nodePort   = 30001 # same port as in ../main.tf
  }]
}

variable "kubeconfig" {
  description = "Path to the Kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "namespace" {
  description = "Namespace where to install the services"
  type        = string
  default     = "istio-system"
}

variable "istio_version" {
  description = "The version of the Istio Helm Chart to be installed"
  type        = string
  default     = "1.20.3"
}

variable "helm_repository" {
  type        = string
  description = "Helm Chart Repository URL"
  default     = "https://istio-release.storage.googleapis.com/charts"
}
