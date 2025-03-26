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
  namespace  = local.target_namespace
  lint       = true
  atomic     = true
  wait       = true
}

resource "helm_release" "istiod" {
  name       = "istiod"
  chart      = "istiod"
  repository = var.helm_repository
  version    = var.helm_version
  namespace  = local.target_namespace
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
    name  = "autoscaleEnabled"
    value = "false"
  }

  set {
    name  = "autoscaleMin"
    value = var.replica_count
  }

  set {
    name  = "replicaCount"
    value = var.replica_count
  }

  set {
    name  = "traceSampling"
    value = var.trace_sampling
  }

  set {
    name  = "global.proxy.tracer"
    value = var.tracer_type
  }

  dynamic "set" {
    for_each = var.tracer_type != "none" ? ([var.tracer_type]) : []
    content {
      name  = "meshConfig.tracing.${var.tracer_type}.address"
      value = var.tracer_address
    }

  }

  depends_on = [helm_release.istio_base]
}

resource "helm_release" "istio_ingressgateway" {
  name       = "istio-ingressgateway"
  chart      = "gateway"
  repository = var.helm_repository
  version    = var.helm_version
  namespace  = local.target_namespace
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
      value = set.value.nodePort
    }
  }
}

resource "helm_release" "istio_egressgateway" {
  name       = "istio-egressgateway"
  chart      = "gateway"
  repository = var.helm_repository
  version    = var.helm_version
  namespace  = local.target_namespace
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
  namespace  = local.target_namespace
  lint       = true
  atomic     = true
  wait       = true

  depends_on = [helm_release.istiod]
}

data "kubernetes_service_v1" "istio_ingress" {
  metadata {
    name      = "istio-ingressgateway"
    namespace = local.target_namespace
  }

  depends_on = [helm_release.istio_ingressgateway]
}
