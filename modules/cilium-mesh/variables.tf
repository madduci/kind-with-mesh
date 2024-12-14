variable "helm_version" {
  description = "The version of the Cilium Helm Chart to be installed"
  type        = string
  default     = "1.16.4"
  validation {
    condition     = can(regex("^[0-9]+.[0-9]+.[0-9]+$", var.helm_version))
    error_message = "The Helm version must be in the format x.y.z"
  }
}

variable "helm_repository" {
  type        = string
  description = "Helm Chart Repository URL"
  default     = "https://helm.cilium.io/"
  validation {
    condition     = can(regex("https://.*", var.helm_repository))
    error_message = "The Helm Repository URL must start with https://"
  }
}

variable "node_port_http" {
  description = "The NodePort for HTTP traffic"
  type        = number
  default     = 30000
  validation {
    condition     = can(regex("^[0-9]+$", var.node_port_http))
    error_message = "The NodePort must be a number"
  }
}

variable "node_port_https" {
  description = "The NodePort for HTTPS traffic"
  type        = number
  default     = 30001
  validation {
    condition     = can(regex("^[0-9]+$", var.node_port_https))
    error_message = "The NodePort must be a number"
  }
}
