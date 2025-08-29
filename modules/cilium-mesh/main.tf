resource "helm_release" "cilium" {
  name       = "cilium"
  chart      = "cilium"
  repository = var.helm_repository
  version    = var.helm_version
  namespace  = "kube-system"
  lint       = true
  atomic     = true
  wait       = true

  set = [{
    name  = "ipam.mode"
    value = "kubernetes"
    },
    {
      name  = "ingressController.service.type"
      value = "NodePort"
    },
    {
      name  = "ingressController.service.insecureNodePort"
      value = var.port_configuration["http"].node_port
    },
    {
      name  = "ingressController.service.secureNodePort"
      value = var.port_configuration["https"].node_port
      }, {
      name  = "ingressController.enabled"
      value = "true"
    },
    {
      name  = "ingressController.default"
      value = "true"
    },
    {
      name  = "ingressController.loadbalancerMode"
      value = "shared"
  }]
}

data "kubernetes_service_v1" "cilium_ingress" {
  metadata {
    name      = "cilium-ingress"
    namespace = "kube-system"
  }

  depends_on = [helm_release.cilium]
}
