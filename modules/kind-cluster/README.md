# kind-cluster

Module to create a new Kubernetes-in-Docker (KIND) Cluster, in a controller and (optional) multi-workers setup.

## Usage

Clone this repository and set the path to this module in your Project.

´´´hcl
module "kind" {
    source = "path/to/this/module"
    
    kubernetes_version = "1.34.0"
    cluster_name = "my_local_cluster"
    worker_nodes = 2 # Create two worker nodes
    kubeconfig_save_path = "./kubeconfig"
}
´´´

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_kind"></a> [kind](#requirement\_kind) | >= 0.9.0, < 1.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kind_cluster.cluster](https://registry.terraform.io/providers/tehcyx/kind/latest/docs/resources/cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Defines the name of the cluster | `string` | `"local-cluster"` | no |
| <a name="input_kubeconfig_save_path"></a> [kubeconfig\_save\_path](#input\_kubeconfig\_save\_path) | Defines the path to save the kubeconfig file | `string` | `"kubeconfig"` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Defines the kubernetes version to be used | `string` | `"v1.34.0"` | no |
| <a name="input_worker_nodes"></a> [worker\_nodes](#input\_worker\_nodes) | Defines the number of worker nodes to be created | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_certificate"></a> [client\_certificate](#output\_client\_certificate) | The client certificate for the kubeconfig |
| <a name="output_client_key"></a> [client\_key](#output\_client\_key) | The client key for the kubeconfig |
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | The cluster CA certificate for the kubeconfig |
| <a name="output_container_port_http"></a> [container\_port\_http](#output\_container\_port\_http) | The Container Port that is mapping the HTTP Port 80 on the host |
| <a name="output_container_port_https"></a> [container\_port\_https](#output\_container\_port\_https) | The Container Port that is mapping the HTTPS Port 443 on the host |
| <a name="output_container_port_istioctl"></a> [container\_port\_istioctl](#output\_container\_port\_istioctl) | The Container Port that is mapping the Istioctl Port 15021 on the host |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | The endpoint of the created cluster |
| <a name="output_http_container_port"></a> [http\_container\_port](#output\_http\_container\_port) | The Container Port that is mapping the Ciliumctl Port 9876 on the host |
| <a name="output_kubeconfig_path"></a> [kubeconfig\_path](#output\_kubeconfig\_path) | Path to the kubeconfig file |
| <a name="output_name"></a> [name](#output\_name) | The name of the created cluster |
<!-- END_TF_DOCS -->