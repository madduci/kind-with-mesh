resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = var.namespace
  }
}

locals {
  target_namespace = kubernetes_namespace_v1.argocd.metadata[0].name
}

resource "helm_release" "argocd" {
  name       = "argo"
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  version    = var.argocd_version
  namespace  = kubernetes_namespace_v1.argocd.metadata[0].name
  lint       = true
  atomic     = true
  wait       = true

  set {
    name  = "namespaceOverride"
    value = kubernetes_namespace_v1.argocd.metadata[0].name
  }
}


# Creates an Ingress Instance for argocd
resource "kubernetes_ingress_v1" "argocd" {
  wait_for_load_balancer = true
  metadata {
    name      = helm_release.argocd.name
    namespace = kubernetes_namespace_v1.argocd.metadata[0].name
    annotations = {
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "nginx.ingress.kubernetes.io/ssl-passthrough"    = "true"
    }
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = "argocd.${var.domain}"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "argo-argocd-server"
              port {
                name = "https"
              }
            }
          }
        }
      }
    }
  }

  depends_on = [helm_release.argocd]
}
