# gateway-api

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 3.0.0, < 4.0.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.0.0, < 3.0.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.0.0, < 4.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.gateway_api_deploy](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kubeconfig_path"></a> [kubeconfig\_path](#input\_kubeconfig\_path) | Path to the kubeconfig file | `string` | n/a | yes |
| <a name="input_release_version"></a> [release\_version](#input\_release\_version) | The version of the release to deploy | `string` | `"v1.4.1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gateway_version"></a> [gateway\_version](#output\_gateway\_version) | The version of the Gateway API CRDs deployed |
<!-- END_TF_DOCS -->