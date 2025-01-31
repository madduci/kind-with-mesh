# kind-with-nginx

This example shows how a KIND (Kubernetes-in-Docker) Cluster, running with an NGINX Ingress Controller, can be created with easy steps.

Additionally, the example will deploy a demo Workload in form of a Nextcloud Pod, deployed using its [official Helm Chart](https://github.com/nextcloud/helm).

The Ingress Controller will map the ports 80 and 443 on the host and expose the Service through it.

## Requirements

The following tools are required for this project:

* `docker` (up and running)
* `terraform` (1.6+) / `opentofu` (1.6+)
* `helm` (3.0+)
* `kind` (0.22.0+)

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
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.17.0 |
| <a name="requirement_kind"></a> [kind](#requirement\_kind) | 0.7.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.35.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.17.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.35.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kind"></a> [kind](#module\_kind) | ../../modules/kind-cluster | n/a |
| <a name="module_nginx_ingress"></a> [nginx\_ingress](#module\_nginx\_ingress) | ../../modules/nginx-ingress | n/a |

## Resources

| Name | Type |
|------|------|
| [helm_release.nextcloud](https://registry.terraform.io/providers/hashicorp/helm/2.17.0/docs/resources/release) | resource |
| [kubernetes_ingress_v1.nextcloud](https://registry.terraform.io/providers/hashicorp/kubernetes/2.35.1/docs/resources/ingress_v1) | resource |
| [kubernetes_namespace_v1.workshop](https://registry.terraform.io/providers/hashicorp/kubernetes/2.35.1/docs/resources/namespace_v1) | resource |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->