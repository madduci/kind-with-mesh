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