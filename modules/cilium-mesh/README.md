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

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 3.0.0, < 4.0.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.36.0, < 3.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.cilium](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_helm_repository"></a> [helm\_repository](#input\_helm\_repository) | Helm Chart Repository URL | `string` | `"https://helm.cilium.io/"` | no |
| <a name="input_helm_version"></a> [helm\_version](#input\_helm\_version) | The version of the Cilium Helm Chart to be installed | `string` | `"1.16.6"` | no |
| <a name="input_node_port_http"></a> [node\_port\_http](#input\_node\_port\_http) | The NodePort for HTTP traffic | `number` | `30000` | no |
| <a name="input_node_port_https"></a> [node\_port\_https](#input\_node\_port\_https) | The NodePort for HTTPS traffic | `number` | `30001` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cilium_http_port"></a> [cilium\_http\_port](#output\_cilium\_http\_port) | The Cilium HTTP port |
| <a name="output_cilium_https_port"></a> [cilium\_https\_port](#output\_cilium\_https\_port) | The Cilium HTTPS port |
<!-- END_TF_DOCS -->