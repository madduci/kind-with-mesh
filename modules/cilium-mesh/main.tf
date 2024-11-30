resource "helm_release" "cilium" {
  name       = "cilium"
  chart      = "cilium"
  repository = var.helm_repository
  version    = var.helm_version
  namespace  = "kube-system"
  lint       = true
  atomic     = true
  wait       = true

  set {
    name  = "ipam.mode"
    value = "kubernetes"
  }

  set {
    name  = "ingressController.service.type"
    value = "NodePort"
  }

  set {
    name  = "ingressController.enabled"
    value = "true"
  }

  set {
    name  = "ingressController.default"
    value = "true"
  }

  set {
    name  = "ingressController.loadbalancerMode"
    value = "shared"
  }

  set {
    name  = "ingressController.default"
    value = "true"
  }
}

data "kubernetes_service_v1" "cilium_ingress" {
  metadata {
    name      = "cilium-ingress"
    namespace = "kube-system"
  }

  depends_on = [helm_release.cilium]
}
