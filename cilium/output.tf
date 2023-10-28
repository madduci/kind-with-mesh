output "cilium_health_port" {
  description = "The Cilium Health port"
  value       = var.status_port.port
}

output "cilium_http_port" {
  description = "The Cilium HTTP port"
  value       = var.insecure_port.port
}

output "cilium_https_port" {
  description = "The Cilium HTTPS port"
  value       = var.secure_port.port
}
