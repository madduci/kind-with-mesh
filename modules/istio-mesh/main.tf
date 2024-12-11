resource "kubernetes_namespace_v1" "istio_system" {
  metadata {
    name = var.namespace
  }
}

locals {
  target_namespace = kubernetes_namespace_v1.istio_system.metadata[0].name
}

resource "helm_release" "istio_base" {
  name       = "istio-base"
  chart      = "base"
  repository = var.helm_repository
  version    = var.helm_version
  namespace  = kubernetes_namespace_v1.istio_system.metadata[0].name
  lint       = true
  atomic     = true
  wait       = true
}

resource "helm_release" "istiod" {
  name       = "istiod"
  chart      = "istiod"
  repository = var.helm_repository
  version    = var.helm_version
  namespace  = kubernetes_namespace_v1.istio_system.metadata[0].name
  lint       = true
  atomic     = true
  wait       = true

  set {
    name  = "autoscaleEnabled"
    value = "false"
  }

  set {
    name  = "global.logAsJson"
    value = "true"
  }

  set {
    name  = "meshConfig.tracing.zipkin.address"
    value = "zipkin.${kubernetes_namespace_v1.istio_system.metadata[0].name}:9411"
  }

  depends_on = [helm_release.istio_base]
}

resource "helm_release" "istio_ingressgateway" {
  name       = "istio-ingressgateway"
  chart      = "gateway"
  repository = var.helm_repository
  version    = var.helm_version
  namespace  = kubernetes_namespace_v1.istio_system.metadata[0].name
  lint       = true
  atomic     = true
  wait       = true

  depends_on = [helm_release.istiod]

  set {
    name  = "autoscaling.enabled"
    value = "false"
  }

  set {
    name  = "service.type"
    value = "NodePort"
  }

  set {
    name  = "service.ports[${index(var.local_node_ports_istio, set.value)}].name"
    value = set.value.name
  }
}

resource "helm_release" "istio_egressgateway" {
  name       = "istio-egressgateway"
  chart      = "gateway"
  repository = var.helm_repository
  version    = var.helm_version
  namespace  = kubernetes_namespace_v1.istio_system.metadata[0].name
  lint       = true
  atomic     = true
  wait       = true

  depends_on = [helm_release.istiod]

  values = [<<-YAML
    gateway.selectorLabels:
      ingress-ready: "true"
  YAML  
  ]

  set {
    name  = "autoscaling.enabled"
    value = "false"
  }

  # Egress gateways do not need an external LoadBalancer IP
  set {
    name  = "service.type"
    value = "ClusterIP"
  }
}

resource "helm_release" "istio_cni" {
  name       = "istio-cni"
  chart      = "cni"
  repository = var.helm_repository
  version    = var.helm_version
  namespace  = kubernetes_namespace_v1.istio_system.metadata[0].name
  lint       = true
  atomic     = true
  wait       = true

  depends_on = [helm_release.istiod]
}

data "kubernetes_service_v1" "istio_ingress" {
  metadata {
    name      = "istio-ingressgateway"
    namespace = kubernetes_namespace_v1.istio_system.metadata[0].name
  }

  depends_on = [helm_release.istio_ingressgateway]
}
