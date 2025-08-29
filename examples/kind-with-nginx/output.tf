output "nginx_ingress_port_info" {
  description = "The nginx Ingress Information"
  value       = module.nginx_ingress.ingress_port_info
}