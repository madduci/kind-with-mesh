# nginx-ingress

Module to configure a nginx-ingress in a running cluster.

## Usage

Clone this repository and set the path to this module in your Project.

´´´hcl
module "nginx_ingress" {
    source = "path/to/this/module"
    ingress_nginx_version = "1.11.3"
}
´´´

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_cluster_role_binding_v1.ingress_nginx](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding_v1) | resource |
| [kubernetes_cluster_role_binding_v1.ingress_nginx_admission](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding_v1) | resource |
| [kubernetes_cluster_role_v1.ingress_nginx](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_v1) | resource |
| [kubernetes_cluster_role_v1.ingress_nginx_admission](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_v1) | resource |
| [kubernetes_config_map_v1.ingress_nginx_controller](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map_v1) | resource |
| [kubernetes_deployment_v1.ingress_nginx_controller](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment_v1) | resource |
| [kubernetes_ingress_class_v1.ingressclass_nginx](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_class_v1) | resource |
| [kubernetes_job_v1.ingress_nginx_admission_create](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/job_v1) | resource |
| [kubernetes_job_v1.ingress_nginx_admission_patch](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/job_v1) | resource |
| [kubernetes_namespace_v1.ingress_nginx](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_role_binding_v1.ingress_nginx](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding_v1) | resource |
| [kubernetes_role_binding_v1.ingress_nginx_admission](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding_v1) | resource |
| [kubernetes_role_v1.ingress_nginx](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_v1) | resource |
| [kubernetes_role_v1.ingress_nginx_admission](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_v1) | resource |
| [kubernetes_secret_v1.service_account_ingress_nginx](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [kubernetes_secret_v1.service_account_ingress_nginx_admission](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [kubernetes_service_account_v1.ingress_nginx](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account_v1) | resource |
| [kubernetes_service_account_v1.ingress_nginx_admission](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account_v1) | resource |
| [kubernetes_service_v1.ingress_nginx_controller](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_v1) | resource |
| [kubernetes_service_v1.ingress_nginx_controller_admission](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_v1) | resource |
| [kubernetes_validating_webhook_configuration_v1.ingress_nginx_admission](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/validating_webhook_configuration_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ingress_nginx_sha256_digest"></a> [ingress\_nginx\_sha256\_digest](#input\_ingress\_nginx\_sha256\_digest) | The sha256 digest of the NGINX Ingress to be installed | `string` | `"d56f135b6462cfc476447cfe564b83a45e8bb7da2774963b00d12161112270b7"` | no |
| <a name="input_ingress_nginx_version"></a> [ingress\_nginx\_version](#input\_ingress\_nginx\_version) | The version of the NGINX Ingress to be installed | `string` | `"1.11.3"` | no |
| <a name="input_ingress_webhook_certgen_sha256_digest"></a> [ingress\_webhook\_certgen\_sha256\_digest](#input\_ingress\_webhook\_certgen\_sha256\_digest) | The sha256 digest of the NGINX Webhook Certificate generator to be installed | `string` | `"a9f03b34a3cbfbb26d103a14046ab2c5130a80c3d69d526ff8063d2b37b9fd3f"` | no |
| <a name="input_ingress_webhook_certgen_version"></a> [ingress\_webhook\_certgen\_version](#input\_ingress\_webhook\_certgen\_version) | The version of the NGINX Webhook Certificate generator to be installed | `string` | `"1.4.4"` | no |
| <a name="input_local_node_ports"></a> [local\_node\_ports](#input\_local\_node\_ports) | Defines the node ports to use with the local cluster (kind) | <pre>list(object({<br/>    app_protocol = string<br/>    name         = string<br/>    target_port  = string<br/>    protocol     = string<br/>    port         = number<br/>    node_port    = number<br/>  }))</pre> | <pre>[<br/>  {<br/>    "app_protocol": "http",<br/>    "name": "http",<br/>    "node_port": 30000,<br/>    "port": 80,<br/>    "protocol": "TCP",<br/>    "target_port": "http"<br/>  },<br/>  {<br/>    "app_protocol": "https",<br/>    "name": "https",<br/>    "node_port": 30001,<br/>    "port": 443,<br/>    "protocol": "TCP",<br/>    "target_port": "https"<br/>  }<br/>]</pre> | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace where to install the services | `string` | `"ingress-nginx"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ingress_nginx_http_port"></a> [ingress\_nginx\_http\_port](#output\_ingress\_nginx\_http\_port) | The NGINX Ingress HTTP port |
| <a name="output_ingress_nginx_https_port"></a> [ingress\_nginx\_https\_port](#output\_ingress\_nginx\_https\_port) | The NGINX Ingress HTTPS port |
<!-- END_TF_DOCS -->