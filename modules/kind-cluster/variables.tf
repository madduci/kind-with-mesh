variable "kubernetes_version" {
  type        = string
  default     = "v1.34.0"
  description = "Defines the kubernetes version to be used"
  validation {
    condition     = can(regex("v[0-9]+.[0-9]+.[0-9]+", var.kubernetes_version))
    error_message = "The Kubernetes version must be in the format v1.x.y"
  }
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
  default     = 1
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

variable "port_configuration" {
  type = map(object({
    app_protocol = string
    node_port    = number
    host_port    = number
    target_port  = number
    protocol     = string
  }))
  description = "Defines the port mappings for the cluster nodes"

  validation {
    condition     = length(var.port_configuration) == length(keys(var.port_configuration))
    error_message = "All port mapping keys must be unique"
  }

  validation {
    condition     = alltrue([for port in values(var.port_configuration) : length(port.app_protocol) > 0])
    error_message = "App Protocol must be a non-empty string"
  }

  validation {
    condition     = alltrue([for port in values(var.port_configuration) : port.node_port > 0 && port.node_port < 65536])
    error_message = "Node Port must be between 1 and 65535"
  }

  validation {
    condition     = alltrue([for port in values(var.port_configuration) : port.host_port > 0 && port.host_port < 65536])
    error_message = "Host Port must be between 1 and 65535"
  }

  validation {
    condition     = alltrue([for port in values(var.port_configuration) : port.target_port > 0 && port.target_port < 65536])
    error_message = "Target Port must be between 1 and 65535"
  }

  validation {
    condition     = alltrue([for port in values(var.port_configuration) : can(regex("TCP|UDP", port.protocol))])
    error_message = "Protocol must be either TCP or UDP"
  }

  default = {
    http = {
      app_protocol = "http"
      node_port    = 30000
      host_port    = 80
      target_port  = 80
      protocol     = "TCP"
    }
    https = {
      app_protocol = "https"
      node_port    = 30001
      host_port    = 443
      target_port  = 443
      protocol     = "TCP"
    }
  }
}
