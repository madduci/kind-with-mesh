variable "release_version" {
  description = "The version of the release to deploy"
  type        = string
  default     = "v1.4.1"

  validation {
    condition     = can(regex("^v?\\d+\\.\\d+\\.\\d+$", var.release_version))
    error_message = "The release version must be in the format 'vX.Y.Z' or 'X.Y.Z'"
  }
}

variable "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  type        = string

  validation {
    condition     = fileexists(var.kubeconfig_path) || length(var.kubeconfig_path) > 0
    error_message = "The kubeconfig path must point to an existing file"
  }
}