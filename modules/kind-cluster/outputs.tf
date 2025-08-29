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

output "cluster_port_info" {
  description = "The port configuration for the created cluster"
  value       = var.port_configuration
}