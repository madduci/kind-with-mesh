# istio-mesh

Module to configure a Service Mesh with Istio.

## Usage

Clone this repository and set the path to this module in your Project.

´´´hcl
module "istio" {
    source = "path/to/this/module"

    helm_version = "1.24.1"
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
| [helm_release.istio_base](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istio_cni](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istio_egressgateway](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istio_ingressgateway](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istiod](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace_v1.istio_system](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_service_v1.istio_ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service_v1) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_helm_repository"></a> [helm\_repository](#input\_helm\_repository) | Helm Chart Repository URL | `string` | `"https://istio-release.storage.googleapis.com/charts"` | no |
| <a name="input_helm_version"></a> [helm\_version](#input\_helm\_version) | The version of the Istio Helm Chart to be installed | `string` | `"1.24.1"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace where to install the services | `string` | `"istio-system"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_istio_http_port"></a> [istio\_http\_port](#output\_istio\_http\_port) | The Istio HTTP port |
| <a name="output_istio_https_port"></a> [istio\_https\_port](#output\_istio\_https\_port) | The Istio HTTPS port |
<!-- END_TF_DOCS -->