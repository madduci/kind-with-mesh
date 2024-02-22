variable "kubernetes_version" {
  type        = string
  default     = "v1.29.1"
  description = "Defines the kubernetes version to use"
}

variable "cluster_name" {
  type        = string
  default     = "local-cluster"
  description = "Defines the name of the cluster"
}

variable "enable_istio" {
  type        = bool
  default     = false
  description = "Defines if Istio should be installed"
}

variable "enable_cilium" {
  type        = bool
  default     = false
  description = "Defines if Cilium should be installed"
}