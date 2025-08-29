# istio-mesh

Module to configure a Service Mesh with Cilium.

## Usage

Clone this repository and set the path to this module in your Project.

´´´hcl
module "cilium" {
    source = "path/to/this/module"

    helm_version = "1.18.1"
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
| <a name="input_helm_version"></a> [helm\_version](#input\_helm\_version) | The version of the Cilium Helm Chart to be installed | `string` | `"1.18.1"` | no |
| <a name="input_port_configuration"></a> [port\_configuration](#input\_port\_configuration) | Defines the port mappings for the cluster nodes | <pre>map(object({<br/>    app_protocol = string<br/>    node_port    = number<br/>    host_port    = number<br/>    target_port  = number<br/>    protocol     = string<br/>  }))</pre> | <pre>{<br/>  "cilium-port": {<br/>    "app_protocol": "http",<br/>    "host_port": 9876,<br/>    "node_port": 30003,<br/>    "protocol": "TCP",<br/>    "target_port": 9876<br/>  },<br/>  "http": {<br/>    "app_protocol": "http",<br/>    "host_port": 80,<br/>    "node_port": 30000,<br/>    "protocol": "TCP",<br/>    "target_port": 80<br/>  },<br/>  "https": {<br/>    "app_protocol": "https",<br/>    "host_port": 443,<br/>    "node_port": 30001,<br/>    "protocol": "TCP",<br/>    "target_port": 443<br/>  }<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ingress_port_info"></a> [ingress\_port\_info](#output\_ingress\_port\_info) | The Cilium Ingress Information |
<!-- END_TF_DOCS -->