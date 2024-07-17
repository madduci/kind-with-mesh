variable "kubernetes_version" {
  type        = string
  default     = "v1.30.2"
  description = "Defines the kubernetes version to be used"
}

variable "cluster_name" {
  type        = string
  default     = "local-cluster"
  description = "Defines the name of the cluster"
  validation {
    condition     = length(var.cluster_name) > 0
    error_message = "The cluster name must not be empty"
  }
}

variable "worker_nodes" {
  type        = number
  default     = 3
  description = "Defines the number of worker nodes to be created"
  validation {
    condition     = var.worker_nodes > 0
    error_message = "The number of worker nodes must be at least 1"
  }
}

variable "kubeconfig_save_path" {
  type        = string
  description = "Defines the path to save the kubeconfig file"
  default     = "kubeconfig"
  validation {
    condition     = length(var.kubeconfig_save_path) > 0
    error_message = "The kubeconfig save path must not be empty"
  }
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