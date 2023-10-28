
resource "helm_release" "istio_base" {
  name       = "istio-base"
  chart      = "base"
  repository = var.helm_repository
  version    = var.istio_version
  namespace  = kubernetes_namespace_v1.istio-system.metadata[0].name
  lint       = true
  atomic     = true
  wait       = true
}

resource "helm_release" "istiod" {
  name       = "istiod"
  chart      = "istiod"
  repository = var.helm_repository
  version    = var.istio_version
  namespace  = kubernetes_namespace_v1.istio-system.metadata[0].name
  lint       = true
  atomic     = true
  wait       = true

  set {
    name  = "pilot.autoscaleEnabled"
    value = "false"
  }

  set {
    name  = "logAsJson"
    value = "true"
  }

  set {
    name  = "meshConfig.tracing.zipkin.address"
    value = "zipkin.istio-system:9411"
  }

  depends_on = [helm_release.istio_base]
}

resource "helm_release" "istio_ingressgateway" {
  name       = "istio-ingressgateway"
  chart      = "gateway"
  repository = var.helm_repository
  version    = var.istio_version
  namespace  = kubernetes_namespace_v1.istio-system.metadata[0].name
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

  dynamic "set" {
    for_each = toset(var.local_node_ports_istio)
    content {
      name  = "service.ports[${index(var.local_node_ports_istio, set.value)}].name"
      value = set.value.name
    }
  }

  dynamic "set" {
    for_each = toset(var.local_node_ports_istio)
    content {
      name  = "service.ports[${index(var.local_node_ports_istio, set.value)}].protocol"
      value = set.value.protocol
    }
  }

  dynamic "set" {
    for_each = toset(var.local_node_ports_istio)
    content {
      name  = "service.ports[${index(var.local_node_ports_istio, set.value)}].port"
      value = set.value.port
    }
  }

  dynamic "set" {
    for_each = toset(var.local_node_ports_istio)
    content {
      name  = "service.ports[${index(var.local_node_ports_istio, set.value)}].targetPort"
      value = set.value.targetPort
    }
  }

  dynamic "set" {
    for_each = toset(var.local_node_ports_istio)
    content {
      name  = "service.ports[${index(var.local_node_ports_istio, set.value)}].nodePort"
      value = set.value.nodePort # same port as in ../cluster/main.tf
    }
  }

}

resource "helm_release" "istio_egressgateway" {
  name       = "istio-egressgateway"
  chart      = "gateway"
  repository = var.helm_repository
  version    = var.istio_version
  namespace  = kubernetes_namespace_v1.istio-system.metadata[0].name
  lint       = true
  atomic     = true
  wait       = true

  depends_on = [helm_release.istiod]

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
