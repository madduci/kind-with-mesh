variable "namespace" {
  description = "Namespace where to install the services"
  type        = string
  default     = "ingress-nginx"
}

variable "ingress_nginx_version" {
  description = "The version of the NGINX Ingress to be installed"
  type        = string
  default     = "1.11.3"
  validation {
    condition     = can(regex("^[0-9]+.[0-9]+.[0-9]+$", var.ingress_nginx_version))
    error_message = "The NGINX Ingress version must be in the format x.y.z"
  }
}

variable "ingress_nginx_sha256_digest" {
  description = "The sha256 digest of the NGINX Ingress to be installed"
  type        = string
  default     = "d56f135b6462cfc476447cfe564b83a45e8bb7da2774963b00d12161112270b7"
  validation {
    condition     = can(regex("^[a-f0-9]{64}$", var.ingress_nginx_sha256_digest))
    error_message = "The sha256 digest must be a valid sha256 hash"
  }
}

variable "ingress_webhook_certgen_version" {
  description = "The version of the NGINX Webhook Certificate generator to be installed"
  type        = string
  default     = "1.4.4"
  validation {
    condition     = can(regex("^[0-9]+.[0-9]+.[0-9]+$", var.ingress_webhook_certgen_version))
    error_message = "The NGINX Webhook Certificate generator version must be in the format x.y.z"
  }
}

variable "ingress_webhook_certgen_sha256_digest" {
  description = "The sha256 digest of the NGINX Webhook Certificate generator to be installed"
  type        = string
  default     = "a9f03b34a3cbfbb26d103a14046ab2c5130a80c3d69d526ff8063d2b37b9fd3f"
  validation {
    condition     = can(regex("^[a-f0-9]{64}$", var.ingress_webhook_certgen_sha256_digest))
    error_message = "The sha256 digest must be a valid sha256 hash"
  }
}

variable "local_node_ports" {
  description = "Defines the node ports to use with the local cluster (kind)"
  type = list(object({
    app_protocol = string
    name         = string
    target_port  = string
    protocol     = string
    port         = number
    node_port    = number
  }))
  default = [
    {
      app_protocol = "http"
      name         = "http"
      target_port  = "http"
      protocol     = "TCP"
      port         = 80
      node_port    = 30000
    },
    {
      app_protocol = "https"
      name         = "https"
      target_port  = "https"
      protocol     = "TCP"
      port         = 443
      node_port    = 30001
  }]
}
