# Creates a Namespace
resource "kubernetes_namespace_v1" "workshop" {
  metadata {
    name = "workshop"
  }

  depends_on = [module.nginx_ingress]
}

# Deploys the Helm Chart
# Options can be found here: https://artifacthub.io/packages/helm/nextcloud/nextcloud
resource "helm_release" "nextcloud" {
  name       = "nextcloud"
  chart      = "nextcloud"
  repository = "https://nextcloud.github.io/helm/"
  version    = "7.0.2"
  namespace  = kubernetes_namespace_v1.workshop.metadata[0].name
  lint       = true
  atomic     = true
  wait       = true
}

# Creates an Ingress Instance for nextcloud
resource "kubernetes_ingress_v1" "nextcloud" {
  wait_for_load_balancer = true
  metadata {
    name      = helm_release.nextcloud.name
    namespace = kubernetes_namespace_v1.workshop.metadata[0].name
  }
  spec {
    ingress_class_name = "nginx"
    default_backend {
      service {
        name = helm_release.nextcloud.name
        port {
          number = 8080
        }
      }
    }
  }

  depends_on = [helm_release.nextcloud, module.nginx_ingress[0]]
}
