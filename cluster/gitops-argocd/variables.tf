variable "namespace" {
  description = "Namespace where to install the services"
  type        = string
  default     = "argocd"
}

variable "argocd_version" {
  description = "The version of the ArgoCD Helm Chart to be installed"
  type        = string
  default     = "7.3.11"
}

variable "helm_repository" {
  type        = string
  description = "Helm Chart Repository URL"
  default     = "https://argoproj.github.io/argo-helm"
}

variable "domain" {
  description = "Domain to use for the Ingress access to ArgoCD"
  type        = string
  default     = "example.com"
}