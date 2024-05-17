variable "helm_version" {
  description = "The version of the Cilium Helm Chart to be installed"
  type        = string
  default     = "1.15.5"
}

variable "helm_repository" {
  type        = string
  description = "Helm Chart Repository URL"
  default     = "https://helm.cilium.io/"
}