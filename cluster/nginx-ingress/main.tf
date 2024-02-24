resource "kubernetes_namespace_v1" "ingress_nginx" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "ingress_nginx" {
  chart         = "ingress-nginx"
  name          = "ingress-nginx"
  repository    = var.helm_repository
  version       = var.helm_version
  namespace     = kubernetes_namespace_v1.ingress_nginx.metadata[0].name
  lint          = true
  atomic        = true
  wait          = true
  wait_for_jobs = true

  values = [<<-YAML
    controller:
      nodeSelector:
        scope: ingress
      tolerations:
        - key: "node-role.kubernetes.io/master"
          operator: "Equal"
          effect: "NoSchedule"
        - key: "node-role.kubernetes.io/control-plane"
          operator: "Equal"
          effect: "NoSchedule"        
    YAML
  ]

  set {
    name  = "controller.service.type"
    value = "NodePort"
  }

  set {
    name = "controller.ingressClassResource.default"
    value = "true"
  }
}


data "kubernetes_service_v1" "ingress_nginx" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata[0].name
  }

  depends_on = [helm_release.ingress_nginx]
}