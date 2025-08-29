# kind-with-nginx

This example shows how a KIND (Kubernetes-in-Docker) Cluster, running with an NGINX Ingress Controller, can be created with easy steps.

Additionally, the example will deploy a demo Workload in form of a Nextcloud Pod, deployed using its [official Helm Chart](https://github.com/nextcloud/helm).

The Ingress Controller will map the ports 80 and 443 on the host and expose the Service through it.

## Requirements

The following tools are required for this project:

* `docker` (up and running)
* `terraform` (1.6+) / `opentofu` (1.6+)
* `helm` (3.0+)
* `kind` (0.30.0+)

## How to run the example

In a Terminal, type the following commands to initialize the Terraform/OpenTofu Workspace and create the cluster:

```sh
export TF_BIN=tofu # change to `terraform` if you want to use Terraform instead of OpenTofu
$TF_BIN init
$TF_BIN plan
$TF_BIN apply
```

After the completion of the above described commands, if no error has been returned, you should see that 2 Containers are running: 

* the Kubernetes Control Plane
* a Worker Node where the Workload (Nextcloud) is deployed

Additionally, a new file, `kubeconfig`, will be placed in this folder, giving you the possibility to authenticate yourself against the cluster and inspect it with your favorite tool (e.g. k9s, headlamp, Lens).

You can now access Nextcloud at the following address:

`https://localhost/`

## How to destroy the cluster

In a Terminal, you can simply run:

```sh
export TF_BIN=tofu # change to `terraform` if you want to use Terraform instead of OpenTofu
$TF_BIN destroy
```

and all the resources will be deleted.
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 3.0.2 |
| <a name="requirement_kind"></a> [kind](#requirement\_kind) | 0.9.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.38.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kind"></a> [kind](#module\_kind) | ../../modules/kind-cluster | n/a |
| <a name="module_nginx_ingress"></a> [nginx\_ingress](#module\_nginx\_ingress) | ../../modules/nginx-ingress | n/a |

## Resources

| Name | Type |
|------|------|
| [helm_release.nextcloud](https://registry.terraform.io/providers/hashicorp/helm/3.0.2/docs/resources/release) | resource |
| [kubernetes_ingress_v1.nextcloud](https://registry.terraform.io/providers/hashicorp/kubernetes/2.38.0/docs/resources/ingress_v1) | resource |
| [kubernetes_namespace_v1.workshop](https://registry.terraform.io/providers/hashicorp/kubernetes/2.38.0/docs/resources/namespace_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_port_configuration"></a> [port\_configuration](#input\_port\_configuration) | Defines the port mappings for the cluster nodes | <pre>map(object({<br/>    app_protocol = string<br/>    node_port    = number<br/>    host_port    = number<br/>    target_port  = number<br/>    protocol     = string<br/>  }))</pre> | <pre>{<br/>  "http": {<br/>    "app_protocol": "http",<br/>    "host_port": 80,<br/>    "node_port": 30000,<br/>    "protocol": "TCP",<br/>    "target_port": 80<br/>  },<br/>  "https": {<br/>    "app_protocol": "https",<br/>    "host_port": 443,<br/>    "node_port": 30001,<br/>    "protocol": "TCP",<br/>    "target_port": 443<br/>  }<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nginx_ingress_port_info"></a> [nginx\_ingress\_port\_info](#output\_nginx\_ingress\_port\_info) | The nginx Ingress Information |
<!-- END_TF_DOCS -->