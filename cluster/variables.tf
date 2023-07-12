variable "kubernetes_version" {
  type        = string
  default     = "v1.26.6"
  description = "Defines the kubernetes version to use"
}

variable "cluster_name" {
  type        = string
  default     = "local-cluster"
  description = "Defines the name of the cluster"
}
