# kind-with-mesh

[![Terraform Plan](https://github.com/madduci/kind-with-mesh/actions/workflows/terraform-plan.yaml/badge.svg)](https://github.com/madduci/kind-with-mesh/actions/workflows/terraform-plan.yaml) [![OpenTofu Plan](https://github.com/madduci/kind-with-mesh/actions/workflows/opentofu-plan.yaml/badge.svg)](https://github.com/madduci/kind-with-mesh/actions/workflows/opentofu-plan.yaml)

This Terraform project allows an user create a local Kubernetes Cluster using the [Kubernetes-in-Docker Stack](https://github.com/kubernetes-sigs/kind) (KIND) and configuring optionally one between NGINX-Ingress (default), Istio or Cilium.

The following steps are performed within the project:

* A local cluster composed by a Control-Plane node and one or more Worker-Nodes is bootstrapped (defaults to 3)
* The Ports 80, 443, 9879 and 15021 are bound on the host, mapping NodePorts on the Control-Plane Node
* A `kubeconfig` file is created locally in the project folder
* The namespace `ingress-nginx` with the NGINX Ingress controller is created, if it is enabled
* The namespace `istio-system` with the basic Istio services is created, if Istio is enabled
* When choosing Cilium, the services will be installed in the `kube-system` namespace

In case of further operations/configuration of the Kind cluster, it's suggested to download the latest release of the `kind` tool from the [GitHub Repository](https://github.com/kubernetes-sigs/kind/releases/latest).

## Requirements

The following tools are required for this project:

* `docker` (up and running)
* `terraform` (1.6+) / `opentofu` (1.6+)
* `helm` (3.0+)
* `kind` (0.30.0+)

## Creating the Cluster

Please see the `examples`, corresponding to the type of cluster that you want to bootstrap (with nginx, istio or cilium).

You can create a cluster from the root path of this repository, by typing one of the following commands:

`make create-cluster-nginx` for a KIND cluster with the nginx Ingress controller

`make create-cluster-istio` for a KIND cluster with the Istio service mesh components

`make create-cluster-cilium` for a KIND cluster with the Cilium service mesh components

### Running multiple clusters on the same host

It is possible to run multiple clusters on the same machine, all you need to do is to modify the port configuration of the additional clusters, specifically the `node_port` and the `host_port` must be different and not overlap with previously used ones, in the `example` folders.