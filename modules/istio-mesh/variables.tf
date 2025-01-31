variable "namespace" {
  description = "Namespace where to install the services"
  type        = string
  default     = "istio-system"
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.namespace))
    error_message = "The namespace must be in lowercase and contain only letters, numbers, and hyphens"
  }
}

variable "helm_version" {
  description = "The version of the Istio Helm Chart to be installed"
  type        = string
  default     = "1.24.2"
  validation {
    condition     = can(regex("^[0-9]+.[0-9]+.[0-9]+$", var.helm_version))
    error_message = "The Helm version must be in the format x.y.z"
  }
}

variable "helm_repository" {
  type        = string
  description = "Helm Chart Repository URL"
  default     = "https://istio-release.storage.googleapis.com/charts"
  validation {
    condition     = can(regex("https://.*", var.helm_repository)) || can(regex("oci://.*", var.helm_repository))
    error_message = "The Helm Repository URL must start with https:// or oci://"
  }
}

variable "local_node_ports_istio" {
  description = "Defines the node ports to use with the local cluster (kind)"
  type = list(object({
    port       = number
    targetPort = number
    name       = string
    protocol   = string
    nodePort   = string
  }))
  default = [{
    name       = "status-port"
    protocol   = "TCP"
    port       = 15021
    targetPort = 15021
    nodePort   = 30002
    },
    {
      name       = "http2"
      protocol   = "TCP"
      port       = 80
      targetPort = 80
      nodePort   = 30000
    },
    {
      name       = "https"
      protocol   = "TCP"
      port       = 443
      targetPort = 443
      nodePort   = 30001
  }]
}

variable "replica_count" {
  description = "The number of replicas that have to be configured for the services"
  type        = number
  default     = 3
  validation {
    condition     = var.replica_count > 1
    error_message = "Error: The replica count must be greater than 1"
  }
}

variable "trace_sampling" {
  description = "The sampling rate option can be used to control what percentage of requests get reported to your tracing system. (https://istio.io/latest/docs/tasks/observability/distributed-tracing/mesh-and-proxy-config/#customizing-trace-sampling)"
  type        = string
  default     = "1.0"
  validation {
    condition     = tonumber(var.trace_sampling) > 0 && tonumber(var.trace_sampling) <= 100
    error_message = "Error: Invalid tracing sampling value. It must be between 1.0 and 100.0"
  }
}

variable "ingress_annotations" {
  description = "The annotations to be used for the ingress gateway"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "external_ip" {
  description = "The external IP of the ingress gateway, only single IP is supported"
  type        = string
  default     = ""
}

variable "tracer_type" {
  description = "The type of tracer to be used"
  type        = string
  default     = "none"
  validation {
    condition     = contains(["zipkin", "lightstep", "datadog", "stackdriver", "none"], var.tracer_type)
    error_message = "Error: The tracer type must be one of: zipkin, lightstep, datadog, stackdriver, none."
  }
}

variable "tracer_address" {
  description = "Address of the tracer to be used"
  type        = string
  default     = ""
}