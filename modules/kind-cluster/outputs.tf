output "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  value       = kind_cluster.cluster.kubeconfig_path
}

output "endpoint" {
  description = "The endpoint of the created cluster"
  value       = kind_cluster.cluster.endpoint
}

output "client_certificate" {
  description = "The client certificate for the kubeconfig"
  value       = kind_cluster.cluster.client_certificate
}

output "client_key" {
  description = "The client key for the kubeconfig"
  value       = kind_cluster.cluster.client_key
}

output "cluster_ca_certificate" {
  description = "The cluster CA certificate for the kubeconfig"
  value       = kind_cluster.cluster.cluster_ca_certificate
}

output "name" {
  description = "The name of the created cluster"
  value       = kind_cluster.cluster.name
}

output "container_port_http" {
  description = "The Container Port that is mapping the HTTP Port 80 on the host"
  value = 30000
}

output "container_port_https" {
  description = "The Container Port that is mapping the HTTPS Port 443 on the host"
  value = 30001
}

output "container_port_istioctl" {
  description = "The Container Port that is mapping the Istioctl Port 15021 on the host"
  value = 30002
}

output "http_container_port" {
  description = "The Container Port that is mapping the Ciliumctl Port 9876 on the host"
  value = 30003
}