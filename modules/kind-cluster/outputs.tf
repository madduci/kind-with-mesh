output "cluster_endpoint" {
  description = "The endpoint of the created kind cluster"
  value       = kind_cluster.cluster.endpoint
}

output "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  value       = kind_cluster.cluster.kubeconfig_path
}