variable "namespace" {
  description = "Namespace where to install the services"
  type        = string
  default     = "ingress-nginx"
}

variable "helm_version" {
  description = "The version of the NGINX Ingress Helm Chart to be installed"
  type        = string
  default     = "4.9.1"
}

variable "helm_repository" {
  type        = string
  description = "Helm Chart Repository URL"
  default     = "https://kubernetes.github.io/ingress-nginx"
}

