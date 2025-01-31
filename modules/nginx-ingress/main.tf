resource "kubernetes_namespace_v1" "ingress_nginx" {
  metadata {
    name = var.namespace
    labels = {
      "kubernetes.io/metadata.name" : "ingress-nginx"
      "name" : "ingress-nginx"
      "pod-security.kubernetes.io/warn" : "restricted"
      "pod-security.kubernetes.io/warn-version" : "v1.32"
    }
  }
}

locals {
  target_namespace = kubernetes_namespace_v1.ingress_nginx.metadata[0].name
}

resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  chart      = "ingress-nginx"
  repository = var.helm_repository
  version    = var.helm_version
  namespace  = local.target_namespace
  lint       = true
  atomic     = true
  wait       = true

  timeout = 120

  values = [<<EOF
  controller:
    service:
      type: NodePort
      nodePorts:
        http: ${var.local_node_ports[0].node_port}
        https: ${var.local_node_ports[1].node_port}
    nodeSelector:
      ${var.toleration_label}: 
    hostPort:
      enabled: true
    tolerations:
      - key: ${var.toleration_label}
        operator: Exists
        effect: NoSchedule
    admissionWebhooks:
      patch:
        tolerations:
          - key: ${var.toleration_label}
            operator: Exists
            effect: NoSchedule
  EOF
  ]
}
