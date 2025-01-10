# istio-mesh

Module to configure a Service Mesh with Cilium.

## Usage

Clone this repository and set the path to this module in your Project.

´´´hcl
module "cilium" {
    source = "path/to/this/module"

    helm_version = "1.16.5"
}
´´´

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.cilium](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_service_v1.cilium_ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service_v1) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_helm_repository"></a> [helm\_repository](#input\_helm\_repository) | Helm Chart Repository URL | `string` | `"https://helm.cilium.io/"` | no |
| <a name="input_helm_version"></a> [helm\_version](#input\_helm\_version) | The version of the Cilium Helm Chart to be installed | `string` | `"1.16.5"` | no |
| <a name="input_node_port_http"></a> [node\_port\_http](#input\_node\_port\_http) | The NodePort for HTTP traffic | `number` | `30000` | no |
| <a name="input_node_port_https"></a> [node\_port\_https](#input\_node\_port\_https) | The NodePort for HTTPS traffic | `number` | `30001` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cilium_http_port"></a> [cilium\_http\_port](#output\_cilium\_http\_port) | The Cilium HTTP port |
| <a name="output_cilium_https_port"></a> [cilium\_https\_port](#output\_cilium\_https\_port) | The Cilium HTTPS port |
<!-- END_TF_DOCS -->