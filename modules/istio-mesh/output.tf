output "ingress_port_info" {
  description = "Information about the Istio Ingress Ports"
  value       = var.enable_ambient_mode ? {} : { for entry in data.kubernetes_service_v1.istio_ingress[0].spec[0].port : entry.name => entry.port }
}