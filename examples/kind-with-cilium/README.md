# kind-with-cilium

This example shows how a KIND (Kubernetes-in-Docker) Cluster, configured with Cilium, can be created with easy steps.

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
* two Worker Nodes

Additionally, a new file, `kubeconfig`, will be placed in this folder, giving you the possibility to authenticate yourself against the cluster and inspect it with your favorite tool (e.g. k9s, headlamp, Lens).

At this point you can also use the `cilium-cli` command line tool to verify that the cluster is working with Cilium successfully.

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
| <a name="module_cilium"></a> [cilium](#module\_cilium) | ../../modules/cilium-mesh | n/a |
| <a name="module_kind"></a> [kind](#module\_kind) | ../../modules/kind-cluster | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_port_configuration"></a> [port\_configuration](#input\_port\_configuration) | Defines the port mappings for the cluster nodes | <pre>map(object({<br/>    app_protocol = string<br/>    node_port    = number<br/>    host_port    = number<br/>    target_port  = number<br/>    protocol     = string<br/>  }))</pre> | <pre>{<br/>  "http": {<br/>    "app_protocol": "http",<br/>    "host_port": 80,<br/>    "node_port": 30000,<br/>    "protocol": "TCP",<br/>    "target_port": 80<br/>  },<br/>  "https": {<br/>    "app_protocol": "https",<br/>    "host_port": 443,<br/>    "node_port": 30001,<br/>    "protocol": "TCP",<br/>    "target_port": 443<br/>  }<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cilium_ingress_port_info"></a> [cilium\_ingress\_port\_info](#output\_cilium\_ingress\_port\_info) | The Cilium Ingress Information |
<!-- END_TF_DOCS -->