
resource "kubernetes_service_account_v1" "ingress_nginx" {
  metadata {
    name      = "ingress-nginx"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata.0.name
    labels    = local.controller_labels
  }

  automount_service_account_token = true
}

resource "kubernetes_secret_v1" "service_account_ingress_nginx" {
  metadata {
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata.0.name
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account_v1.ingress_nginx.metadata.0.name
    }
    labels        = local.controller_labels
    generate_name = "${kubernetes_service_account_v1.ingress_nginx.metadata.0.name}-"
  }

  type                           = "kubernetes.io/service-account-token"
  wait_for_service_account_token = true
}


resource "kubernetes_role_v1" "ingress_nginx" {
  metadata {
    name      = "ingress-nginx"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata.0.name
    labels    = local.controller_labels
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces"]
    verbs      = ["get"]
  }
  rule {
    api_groups = [""]
    resources  = ["configmaps", "pods", "secrets", "endpoints"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["services"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses/status"]
    verbs      = ["update"]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingressclasses"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups     = ["coordination.k8s.io"]
    resource_names = ["ingress-nginx-leader"]
    resources      = ["leases"]
    verbs          = ["get", "update"]
  }
  rule {
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
    verbs      = ["create"]
  }
  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["create", "patch"]
  }
  rule {
    api_groups = ["discovery.k8s.io"]
    resources  = ["endpointslices"]
    verbs      = ["list", "watch", "get"]
  }
}

resource "kubernetes_cluster_role_v1" "ingress_nginx" {
  metadata {
    name   = "ingress-nginx"
    labels = local.controller_labels
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps", "endpoints", "nodes", "pods", "secrets", "namespaces"]
    verbs      = ["list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["get"]
  }
  rule {
    api_groups = [""]
    resources  = ["services"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
    verbs      = ["list", "watch"]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingressclasses"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses/status"]
    verbs      = ["update"]
  }
  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["create", "patch"]
  }
  rule {
    api_groups = ["discovery.k8s.io"]
    resources  = ["endpointslices"]
    verbs      = ["list", "watch", "get"]
  }
}

resource "kubernetes_role_binding_v1" "ingress_nginx" {
  metadata {
    name      = "ingress-nginx"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata.0.name
    labels    = local.controller_labels
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.ingress_nginx.metadata.0.name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.ingress_nginx.metadata.0.name
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata.0.name
  }
}

resource "kubernetes_cluster_role_binding_v1" "ingress_nginx" {
  metadata {
    name   = "ingress-nginx"
    labels = local.controller_labels
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.ingress_nginx.metadata.0.name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.ingress_nginx.metadata.0.name
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata.0.name
  }
}

resource "kubernetes_config_map_v1" "ingress_nginx_controller" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata.0.name
    labels    = local.controller_labels
  }

  data = {
    allow-snippet-annotations = "false"
  }
}



resource "kubernetes_service_v1" "ingress_nginx_controller" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata.0.name
    labels    = local.controller_labels
  }
  spec {
    ip_families = ["IPv4"]

    ip_family_policy = "SingleStack"

    port {
      app_protocol = "http"
      name         = "http"
      port         = 80
      protocol     = "TCP"
      target_port  = "http"
    }

    port {
      app_protocol = "https"
      name         = "https"
      port         = 443
      protocol     = "TCP"
      target_port  = "https"
    }

    selector = {
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/instance"  = "ingress-nginx"
      "app.kubernetes.io/name"      = "ingress-nginx"
    }
    type = "NodePort"
  }
}


resource "kubernetes_deployment_v1" "ingress_nginx_controller" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata.0.name
    labels    = local.controller_labels
  }

  spec {
    min_ready_seconds      = 0
    revision_history_limit = 10
    selector {
      match_labels = {
        "app.kubernetes.io/component" = "controller"
        "app.kubernetes.io/instance"  = "ingress-nginx"
        "app.kubernetes.io/name"      = "ingress-nginx"
      }
    }
    strategy {
      rolling_update {
        max_unavailable = 1
      }
      type = "RollingUpdate"
    }
    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "controller"
          "app.kubernetes.io/instance"  = "ingress-nginx"
          "app.kubernetes.io/name"      = "ingress-nginx"
        }
      }
      spec {
        container {
          args = [
            "/nginx-ingress-controller",
            "--election-id=ingress-nginx-leader",
            "--controller-class=k8s.io/ingress-nginx",
            "--ingress-class=nginx",
            "--configmap=$(POD_NAMESPACE)/ingress-nginx-controller",
            "--validating-webhook=:8443",
            "--validating-webhook-certificate=/usr/local/certificates/cert",
            "--validating-webhook-key=/usr/local/certificates/key",
            "--watch-ingress-without-class=true",
            "--publish-status-address=localhost",
          ]
          env {
            name = "POD_NAME"
            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }
          env {
            name = "POD_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          env {
            name  = "LD_PRELOAD"
            value = "/usr/local/lib/libmimalloc.so"
          }
          image             = "registry.k8s.io/ingress-nginx/controller:v1.9.6@sha256:1405cc613bd95b2c6edd8b2a152510ae91c7e62aea4698500d23b2145960ab9c"
          image_pull_policy = "IfNotPresent"
          lifecycle {
            pre_stop {
              exec {
                command = [
                  "/wait-shutdown",
                ]
              }
            }
          }
          liveness_probe {
            failure_threshold = 5
            http_get {
              path   = "/healthz"
              port   = 10254
              scheme = "HTTP"
            }
            initial_delay_seconds = 10
            period_seconds        = 10
            success_threshold     = 1
            timeout_seconds       = 1
          }
          name = "controller"
          port {
            container_port = 80
            host_port      = 80
            name           = "http"
            protocol       = "TCP"
          }
          port {
            container_port = 443
            host_port      = 443
            name           = "https"
            protocol       = "TCP"
          }
          port {
            container_port = 8443
            name           = "webhook"
            protocol       = "TCP"
          }
          readiness_probe {
            failure_threshold = 3
            http_get {
              path   = "/healthz"
              port   = 10254
              scheme = "HTTP"
            }

            initial_delay_seconds = 10
            period_seconds        = 10
            success_threshold     = 1
            timeout_seconds       = 1
          }
          resources {
            requests = {
              cpu    = "100m"
              memory = "90Mi"
            }
          }
          security_context {
            allow_privilege_escalation = false
            capabilities {
              add = [
                "NET_BIND_SERVICE",
              ]
              drop = [
                "ALL",
              ]
            }
            read_only_root_filesystem = false
            run_as_non_root           = true
            run_as_user               = 101
            seccomp_profile {
              type = "RuntimeDefault"
            }

          }
          volume_mount {
            mount_path = "/usr/local/certificates/"
            name       = "webhook-cert"
            read_only  = true
          }
        }
        dns_policy = "ClusterFirst"
        node_selector = {
          "ingress-ready"    = "true"
          "kubernetes.io/os" = "linux"
        }

        service_account_name             = kubernetes_service_account_v1.ingress_nginx.metadata.0.name
        termination_grace_period_seconds = 0

        toleration {
          effect   = "NoSchedule"
          key      = "node-role.kubernetes.io/master"
          operator = "Equal"
        }

        toleration {
          effect   = "NoSchedule"
          key      = "node-role.kubernetes.io/control-plane"
          operator = "Equal"
        }

        volume {
          name = "webhook-cert"
          secret {
            secret_name = "ingress-nginx-admission"
          }
        }
      }
    }
  }

  depends_on = [kubernetes_job_v1.ingress_nginx_admission_create, kubernetes_job_v1.ingress_nginx_admission_patch]
}
