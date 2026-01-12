# istio-mesh

Module to configure a Service Mesh with Istio.

## Usage

Clone this repository and set the path to this module in your Project.

´´´hcl
module "istio" {
    source = "path/to/this/module"

    helm_version = "1.27.0"
}
´´´

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 3.0.0, < 4.0.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 3.0.0, < 4.0.0 |

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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_helm_repository"></a> [helm\_repository](#input\_helm\_repository) | Helm Chart Repository URL | `string` | `"https://istio-release.storage.googleapis.com/charts"` | no |
| <a name="input_helm_version"></a> [helm\_version](#input\_helm\_version) | The version of the Istio Helm Chart to be installed | `string` | `"1.28.2"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace where to install the services | `string` | `"istio-system"` | no |
| <a name="input_port_configuration"></a> [port\_configuration](#input\_port\_configuration) | Defines the configuration of the ports to be used by the Istio Ingress Gateway | <pre>map(object({<br/>    app_protocol = string<br/>    node_port    = number<br/>    host_port    = number<br/>    target_port  = number<br/>    protocol     = string<br/>  }))</pre> | <pre>{<br/>  "http": {<br/>    "app_protocol": "http",<br/>    "host_port": 80,<br/>    "node_port": 30000,<br/>    "protocol": "TCP",<br/>    "target_port": 80<br/>  },<br/>  "https": {<br/>    "app_protocol": "https",<br/>    "host_port": 443,<br/>    "node_port": 30001,<br/>    "protocol": "TCP",<br/>    "target_port": 443<br/>  },<br/>  "status-port": {<br/>    "app_protocol": "http",<br/>    "host_port": 15021,<br/>    "node_port": 30002,<br/>    "protocol": "TCP",<br/>    "target_port": 15021<br/>  }<br/>}</pre> | no |
| <a name="input_replica_count"></a> [replica\_count](#input\_replica\_count) | The number of replicas that have to be configured for the services | `number` | `3` | no |
| <a name="input_trace_sampling"></a> [trace\_sampling](#input\_trace\_sampling) | The sampling rate option can be used to control what percentage of requests get reported to your tracing system. (https://istio.io/latest/docs/tasks/observability/distributed-tracing/mesh-and-proxy-config/#customizing-trace-sampling) | `string` | `"1.0"` | no |
| <a name="input_tracer_address"></a> [tracer\_address](#input\_tracer\_address) | Address of the tracer to be used | `string` | `""` | no |
| <a name="input_tracer_type"></a> [tracer\_type](#input\_tracer\_type) | The type of tracer to be used | `string` | `"none"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ingress_port_info"></a> [ingress\_port\_info](#output\_ingress\_port\_info) | Information about the Istio Ingress Ports |
<!-- END_TF_DOCS -->