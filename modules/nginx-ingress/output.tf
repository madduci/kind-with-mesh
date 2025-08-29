output "ingress_port_info" {
  description = "The NGINX Ingress Information"
  value       = { for entry in data.kubernetes_service_v1.nginx_ingress.spec[0].port : entry.name => entry.port }
}
