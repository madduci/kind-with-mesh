# kind-cluster

Module to create a new Kubernetes-in-Docker (KIND) Cluster, in a controller and (optional) multi-workers setup.

## Usage

Clone this repository and set the path to this module in your Project.

´´´hcl
module "kind" {
    source = "path/to/this/module"

    kubernetes_version = "1.31.2"
    cluster_name = "my_local_cluster"
    worker_nodes = 2 # Create two worker nodes
    kubeconfig_save_path = "./kubeconfig"
}
´´´

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kind"></a> [kind](#provider\_kind) | n/a |

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
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Defines the kubernetes version to be used | `string` | `"v1.31.2"` | no |
| <a name="input_worker_nodes"></a> [worker\_nodes](#input\_worker\_nodes) | Defines the number of worker nodes to be created | `number` | `3` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | The endpoint of the created kind cluster |
| <a name="output_kubeconfig_path"></a> [kubeconfig\_path](#output\_kubeconfig\_path) | Path to the kubeconfig file |
<!-- END_TF_DOCS -->