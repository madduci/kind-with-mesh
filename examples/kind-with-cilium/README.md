# kind-with-cilium

This example shows how a KIND (Kubernetes-in-Docker) Cluster, configured with Cilium, can be created with easy steps.

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