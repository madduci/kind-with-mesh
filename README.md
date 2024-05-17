# kind-with-mesh

This Terraform project allows an user create a local Kubernetes Cluster using the [Kubernetes-in-Docker Stack](https://github.com/kubernetes-sigs/kind) (KIND) and configuring optionally one between NGINX-Ingress (default), Istio or Cilium.

The following steps are performed within the project:

* A local cluster composed by a Control-Plane node and one or more Worker-Nodes is bootstrapped
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
* `kind` (0.22.0+)
* `make`

## Creating the Cluster

The bootstrapping and configuration of cluster can be performed with the command:

```sh
cd cluster
terraform init
terraform apply
```

There are variables that can be changed, they hold the following default values:

```hcl
kubernetes_version=v1.30.0
cluster_name=local-cluster
enable_istio=false
enable_cilium=false
```

### Alternative: using Makefile

To simplify the execution of the commands, a `Makefile` is available and this is used to perform the `terraform` commands seamless. All you need to do is to type from the root folder:

```sh
make cluster
```

If you want to delete the cluster, then type:

```sh
make cleanup
```

## Configuring Istio

Istio deploys a Service Mesh, offering the possibility to configure Mutual-TLS between Pods in a cluster, by defining some configurations. It helps to create an Ingress Object, exposing then ports 80, 443 and 15021 outside (as NodePort).

The configuration of the cluster with Istio can be performed with the command:

```sh
cd istio
terraform init
terraform apply -var=enable_istio=true
```

### Alternative: using Makefile

To simplify the execution of the commands, a `Makefile` is available and this is used to perform the `terraform` commands seamless. All you need to do is to type from the root folder:

```sh
make cluster-istio
```

## Configuring Cilium

Cilium deploys a Service Mesh, offering the possibility to configure Mutual-TLS between Pods in a cluster, by defining some configurations. It helps to create an Ingress Object, exposing then ports 80, 443 and 9879 outside (as NodePort).

The configuration of Cilium can be performed with the command:

```sh
cd cilium
terraform init
terraform apply -var=enable_cilium=true
```

### Alternative: using Makefile

To simplify the execution of the commands, a `Makefile` is available and this is used to perform the `terraform` commands seamless. All you need to do is to type from the root folder:

```sh
make cluster-cilium
```
