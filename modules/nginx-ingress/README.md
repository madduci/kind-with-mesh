# nginx-ingress

Module to configure a nginx-ingress in a running cluster.

## Usage

Clone this repository and set the path to this module in your Project.

´´´hcl
module "nginx_ingress" {
    source = "path/to/this/module"
    helm_version = "4.12.5"
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
| [helm_release.ingress_nginx](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace_v1.ingress_nginx](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_helm_repository"></a> [helm\_repository](#input\_helm\_repository) | Helm Chart Repository URL | `string` | `"https://kubernetes.github.io/ingress-nginx"` | no |
| <a name="input_helm_version"></a> [helm\_version](#input\_helm\_version) | The version of the nginx Ingress Controller Helm Chart to be installed | `string` | `"4.12.5"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace where to install the services | `string` | `"ingress-nginx"` | no |
| <a name="input_port_configuration"></a> [port\_configuration](#input\_port\_configuration) | Defines the configuration of the ports to be used by the Ingress Controller | <pre>map(object({<br/>    app_protocol = string<br/>    node_port    = number<br/>    host_port    = number<br/>    target_port  = number<br/>    protocol     = string<br/>  }))</pre> | <pre>{<br/>  "http": {<br/>    "app_protocol": "http",<br/>    "host_port": 80,<br/>    "node_port": 30000,<br/>    "protocol": "TCP",<br/>    "target_port": 80<br/>  },<br/>  "https": {<br/>    "app_protocol": "https",<br/>    "host_port": 443,<br/>    "node_port": 30001,<br/>    "protocol": "TCP",<br/>    "target_port": 443<br/>  }<br/>}</pre> | no |
| <a name="input_toleration_label"></a> [toleration\_label](#input\_toleration\_label) | Defines label to be used for toleration when deploying the Ingress Controller | `string` | `"node-role.kubernetes.io/control-plane"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ingress_port_info"></a> [ingress\_port\_info](#output\_ingress\_port\_info) | The NGINX Ingress Information |
<!-- END_TF_DOCS -->