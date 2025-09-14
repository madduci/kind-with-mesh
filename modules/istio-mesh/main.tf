resource "kubernetes_namespace_v1" "istio_system" {
  metadata {
    name = var.namespace
  }
}

locals {
  target_namespace = kubernetes_namespace_v1.istio_system.metadata[0].name

  port_keys = keys(var.port_configuration)
  helm_ingress_port_values = flatten([
    for key, config in var.port_configuration : [
      {
        name = "service.ports[${index(local.port_keys, key)}].name"
        # For istio, the "http" port must be named "http2"
        value = key == "http" ? "http2" : key
      },
      {
        name  = "service.ports[${index(local.port_keys, key)}].protocol"
        value = config.protocol
      },
      {
        name  = "service.ports[${index(local.port_keys, key)}].port"
        value = config.host_port
      },
      {
        name  = "service.ports[${index(local.port_keys, key)}].targetPort"
        value = config.target_port
      },
      {
        name  = "service.ports[${index(local.port_keys, key)}].nodePort"
        value = config.node_port
      }
    ]
  ])
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

  values = [<<-YAML
    labels:
      ingress-ready: "true"
  YAML  
  ]

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
  ], local.helm_ingress_port_values)
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
    labels:
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
