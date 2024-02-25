locals {
  controller_labels = {
    "app.kubernetes.io/component" = "controller"
    "app.kubernetes.io/instance"  = "ingress-nginx"
    "app.kubernetes.io/name"      = "ingress-nginx"
    "app.kubernetes.io/part-of"   = "ingress-nginx"
    "app.kubernetes.io/version"   = "${var.ingress_nginx_version}"
  }

  admission_labels = {
    "app.kubernetes.io/component" = "admission-webhook"
    "app.kubernetes.io/instance"  = "ingress-nginx"
    "app.kubernetes.io/name"      = "ingress-nginx"
    "app.kubernetes.io/part-of"   = "ingress-nginx"
    "app.kubernetes.io/version"   = "${var.ingress_nginx_version}"
  }
}

resource "kubernetes_namespace_v1" "ingress_nginx" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/instance" = "ingress-nginx"
      "app.kubernetes.io/name"     = "ingress-nginx"
    }
  }
}

resource "kubernetes_ingress_class_v1" "ingressclass_nginx" {
  metadata {
    labels = local.controller_labels
    name   = "nginx"
  }
  spec {
    controller = "k8s.io/ingress-nginx"
  }
}
