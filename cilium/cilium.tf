resource "helm_release" "cilium" {
  name       = "cilium"
  chart      = "cilium"
  repository = var.helm_repository
  version    = var.cilium_version
  namespace  = "kube-system"
  lint       = true
  atomic     = true
  wait       = true

  set {
    name  = "ipam.mode"
    value = "kubernetes"
  }

  set {
    name  = "nodePort.enabled"
    value = "true"
  }

  set {
    name  = "service.type"
    value = "NodePort"
  }

  set {
    name  = "ingressController.service.type"
    value = "NodePort"
  }

  set {
    name  = "ingressController.service.insecureNodePort"
    value = var.insecure_node_port.nodePort
  }

  set {
    name  = "ingressController.service.secureNodePort"
    value = var.secure_node_port.nodePort
  }

  set {
    name  = "ingressController.enabled"
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
