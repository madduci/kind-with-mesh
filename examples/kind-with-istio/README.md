# kind-with-istio

This example shows how a KIND (Kubernetes-in-Docker) Cluster, configured with Istio, can be created with easy steps.

Additionally, the example will deploy a Workload example taken directly from the [Istio Repository](https://github.com/istio/istio), showing the usage of VirtualService and DestinationRule custom resources

The Istio Gateway will map the port 80 and expose the Service through it. If you want to use the HTTPS port, you need to customise the `example.yaml` file and also register a valid key pair to be used for the TLS communication.

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

You can now access the example Service at the following address:

`http://localhost/hello`

You should see the message:

`Hello version: v2, instance: helloworld-v2-<unique-id>`

At this point you can also use the `istioctl` command line tool to verify that the cluster is working with Istio successfully.

## How to destroy the cluster

In a Terminal, you can simply run:

```sh
export TF_BIN=tofu # change to `terraform` if you want to use Terraform instead of OpenTofu
$TF_BIN destroy
```

and all the resources will be deleted.