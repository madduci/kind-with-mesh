variable "helm_version" {
  description = "The version of the Cilium Helm Chart to be installed"
  type        = string
  default     = "1.16.3"
}

variable "helm_repository" {
  type        = string
  description = "Helm Chart Repository URL"
  default     = "https://helm.cilium.io/"
}