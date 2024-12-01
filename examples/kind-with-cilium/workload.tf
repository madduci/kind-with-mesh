# Creates a Namespace
resource "kubernetes_namespace_v1" "workshop" {
  metadata {
    name = "workshop"
  }

  depends_on = [module.cilium]
}

# Deploys the Helm Chart
# Options can be found here: https://artifacthub.io/packages/helm/nextcloud/nextcloud
resource "helm_release" "nextcloud" {
  name       = "nextcloud"
  chart      = "nextcloud"
  repository = "https://nextcloud.github.io/helm/"
  version    = "6.2.4"
  namespace  = kubernetes_namespace_v1.workshop.metadata[0].name
  lint       = true
  atomic     = true
  wait       = true
}
