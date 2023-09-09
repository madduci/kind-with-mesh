# kind-with-istio

This Terraform project allows an user create a local Kubernetes Cluster using the https://github.com/kubernetes-sigs/kind[Kubernetes-in-Docker Stack] (KIND) and configuring the Service Mesh with Istio.

The following steps are performed within the project:

* A local cluster composed by a Control-Plane node and a single Worker-Node is bootstrapped
* The Ports 80, 443 and 15021 are bound on the host, mapping NodePorts on the Control-Plane Node
* A `kubeconfig` file is created locally in the project folder
* The namespace `istio-system` with the basic Istio services is created

In case of further operations/configuration of the Kind cluster, it's suggested to download the latest release of the `kind` tool from the https://github.com/kubernetes-sigs/kind/releases/latest[GitHub Repository].

## Creating the Cluster

The bootstrapping and configuration of cluster can be performed with the command:

```sh
cd cluster
terraform init
terraform apply
```

There are variables that can be changed, they hold the following default values:

```hcl
kubernetes_version=v1.27.3
cluster_name=local-cluster
```

### Alternative: using Makefile

To simplify the execution of the commands, a `Makefile` is available and this is used to perform the `terraform` commands seamless. All you need to do is to type from the root folder:

```sh
make create
```

If you want to delete the cluster, then type:

```sh
make cleanup
```

## Configuring Istio

Istio deploys a Service Mesh, offering the possibility to configure Mutual-TLS between Pods in a cluster, by defining some configurations. It helps to create an Ingress Object, exposing then ports 80, 443 and 15021 outside (as NodePort).

The configuration of Istio can be performed with the command:

```sh
cd istio
terraform init
terraform apply
```

### Alternative: using Makefile

To simplify the execution of the commands, a `Makefile` is available and this is used to perform the `terraform` commands seamless. All you need to do is to type from the root folder:

```sh
make istio
```

The cluster must have been already created with the command `make create`