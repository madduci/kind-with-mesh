#output "ingress_port_info" {
#  description = "Information about the Istio Ingress Ports"
#  value       = { for entry in data.kubernetes_service_v1.istio_ingress.spec[0].port : entry.name => entry.port }
#}