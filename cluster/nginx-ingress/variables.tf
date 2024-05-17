variable "namespace" {
  description = "Namespace where to install the services"
  type        = string
  default     = "ingress-nginx"
}

variable "ingress_nginx_version" {
  description = "The version of the NGINX Ingress to be installed"
  type        = string
  default     = "1.10.1"
}
