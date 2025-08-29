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

  set = concat([
    {
      name  = "autoscaleEnabled"
      value = "false"
    },
    {
      name  = "autoscaleMin"
      value = var.replica_count
    },
    {
      name  = "global.logAsJson"
      value = "true"
    },
    {
      name  = "replicaCount"
      value = var.replica_count
    },
    {
      name  = "traceSampling"
      value = var.trace_sampling
    },
    {
      name  = "global.proxy.tracer"
      value = var.tracer_type
    }
    ], var.tracer_type != "none" ? [{
      name  = "meshConfig.tracing.${var.tracer_type}.address"
      value = var.tracer_address
  }] : [])

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

  set = concat([
    {
      name  = "autoscaling.enabled"
      value = "false"
    },
    {
      name  = "service.type"
      value = "NodePort"
    },
    {
      name  = "replicaCount"
      value = var.replica_count
    }
    ], [
    for port in toset(var.local_node_ports_istio) : {
      name  = "service.ports[${index(var.local_node_ports_istio, port)}].name"
      value = port.name
    }],
    [
      for port in toset(var.local_node_ports_istio) : {
        name  = "service.ports[${index(var.local_node_ports_istio, port)}].protocol"
        value = port.protocol
    }],
    [
      for port in toset(var.local_node_ports_istio) : {
        name  = "service.ports[${index(var.local_node_ports_istio, port)}].port"
        value = port.port
    }],
    [
      for port in toset(var.local_node_ports_istio) :
      {
        name  = "service.ports[${index(var.local_node_ports_istio, port)}].targetPort"
        value = port.targetPort
    }],
    [
      for port in toset(var.local_node_ports_istio) :
      {
        name  = "service.ports[${index(var.local_node_ports_istio, port)}].nodePort"
        value = port.nodePort
      }
  ])

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

  set = [{
    name  = "autoscaling.enabled"
    value = "false"
    },
    {
      # Egress gateways do not need an external LoadBalancer IP
      name  = "service.type"
      value = "ClusterIP"
  }]
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
