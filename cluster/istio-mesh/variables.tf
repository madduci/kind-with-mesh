variable "namespace" {
  description = "Namespace where to install the services"
  type        = string
  default     = "istio-system"
}

variable "helm_version" {
  description = "The version of the Istio Helm Chart to be installed"
  type        = string
  default     = "1.23.2"
}

variable "helm_repository" {
  type        = string
  description = "Helm Chart Repository URL"
  default     = "https://istio-release.storage.googleapis.com/charts"
}
