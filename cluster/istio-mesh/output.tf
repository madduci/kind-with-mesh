output "istio_health_port" {
  description = "The Istio Health port"
  value       = var.local_node_ports_istio[0].port
}

output "istio_http_port" {
  description = "The Istio HTTP port"
  value       = var.local_node_ports_istio[1].port
}

output "istio_https_port" {
  description = "The Istio HTTPS port"
  value       = var.local_node_ports_istio[2].port
}
