# Creates a Namespace
resource "kubernetes_namespace_v1" "workshop" {
  metadata {
    name = "workshop"
    labels = {
      istio-injection = "enabled"
    }
  }

  depends_on = [module.istio]
}

resource "kubernetes_namespace_v1" "ingress" {
  metadata {
    name = "istio-ingress"
  }

  depends_on = [module.istio]
}

resource "kubernetes_manifest" "gateway" {
  count = fileexists("${path.root}/kubeconfig") ? 1 : 0
  manifest = yamldecode(file("${path.root}/gateway.yaml"))

  depends_on = [kubernetes_namespace_v1.ingress]
}

# Wait for the cluster to be ready
resource "null_resource" "install_example" {
  depends_on = [kubernetes_namespace_v1.workshop]

  // trigger again if the content changes
  triggers = {
    hash = filesha256("${path.root}/example.yaml")
  }
  provisioner "local-exec" {
    command = "kubectl apply --namespace ${kubernetes_namespace_v1.workshop.metadata[0].name} -f ${path.root}/example.yaml"
    environment = {
      "KUBECONFIG" = module.kind.kubeconfig_path
    }

  }
}

