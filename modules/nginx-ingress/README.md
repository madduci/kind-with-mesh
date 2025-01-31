# nginx-ingress

Module to configure a nginx-ingress in a running cluster.

## Usage

Clone this repository and set the path to this module in your Project.

´´´hcl
module "nginx_ingress" {
    source = "path/to/this/module"
    helm_version = "4.12.0"
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
| [helm_release.ingress_nginx](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace_v1.ingress_nginx](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_helm_repository"></a> [helm\_repository](#input\_helm\_repository) | Helm Chart Repository URL | `string` | `"https://kubernetes.github.io/ingress-nginx"` | no |
| <a name="input_helm_version"></a> [helm\_version](#input\_helm\_version) | The version of the nginx Ingress Controller Helm Chart to be installed | `string` | `"4.12.0"` | no |
| <a name="input_local_node_ports"></a> [local\_node\_ports](#input\_local\_node\_ports) | Defines the node ports to use with the local cluster (kind) | <pre>list(object({<br/>    app_protocol = string<br/>    name         = string<br/>    target_port  = string<br/>    protocol     = string<br/>    port         = number<br/>    node_port    = number<br/>  }))</pre> | <pre>[<br/>  {<br/>    "app_protocol": "http",<br/>    "name": "http",<br/>    "node_port": 30000,<br/>    "port": 80,<br/>    "protocol": "TCP",<br/>    "target_port": "http"<br/>  },<br/>  {<br/>    "app_protocol": "https",<br/>    "name": "https",<br/>    "node_port": 30001,<br/>    "port": 443,<br/>    "protocol": "TCP",<br/>    "target_port": "https"<br/>  }<br/>]</pre> | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace where to install the services | `string` | `"ingress-nginx"` | no |
| <a name="input_toleration_label"></a> [toleration\_label](#input\_toleration\_label) | Defines label to be used for toleration when deploying the Ingress Controller | `string` | `"node-role.kubernetes.io/control-plane"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ingress_nginx_http_port"></a> [ingress\_nginx\_http\_port](#output\_ingress\_nginx\_http\_port) | The NGINX Ingress HTTP port |
| <a name="output_ingress_nginx_https_port"></a> [ingress\_nginx\_https\_port](#output\_ingress\_nginx\_https\_port) | The NGINX Ingress HTTPS port |
<!-- END_TF_DOCS -->