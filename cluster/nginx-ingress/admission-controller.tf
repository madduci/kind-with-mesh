
resource "kubernetes_service_account_v1" "ingress_nginx_admission" {
  metadata {
    name      = "ingress-nginx-admission"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata.0.name
    labels    = local.admission_labels
  }

  automount_service_account_token = true
}

resource "kubernetes_secret_v1" "service_account_ingress_nginx_admission" {
  metadata {
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata.0.name
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account_v1.ingress_nginx_admission.metadata.0.name
    }
    labels        = local.admission_labels
    generate_name = "${kubernetes_service_account_v1.ingress_nginx_admission.metadata.0.name}-"
  }

  type                           = "kubernetes.io/service-account-token"
  wait_for_service_account_token = true
}

resource "kubernetes_role_v1" "ingress_nginx_admission" {
  metadata {
    name      = "ingress-nginx-admission"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata.0.name
    labels    = local.admission_labels
  }

  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["get", "create"]
  }
}

resource "kubernetes_cluster_role_v1" "ingress_nginx_admission" {
  metadata {
    name   = "ingress-nginx-admission"
    labels = local.admission_labels
  }

  rule {
    api_groups = ["admissionregistration.k8s.io"]
    resources  = ["validatingwebhookconfigurations"]
    verbs      = ["get", "update"]
  }
}


resource "kubernetes_role_binding_v1" "ingress_nginx_admission" {
  metadata {
    name      = "ingress-nginx-admission"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata.0.name
    labels    = local.admission_labels
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.ingress_nginx_admission.metadata.0.name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.ingress_nginx_admission.metadata.0.name
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata.0.name
  }
}

resource "kubernetes_cluster_role_binding_v1" "ingress_nginx_admission" {
  metadata {
    name   = "ingress-nginx-admission"
    labels = local.admission_labels
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.ingress_nginx_admission.metadata.0.name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.ingress_nginx_admission.metadata.0.name
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata.0.name
  }
}

resource "kubernetes_service_v1" "ingress_nginx_controller_admission" {
  metadata {
    name      = "ingress-nginx-controller-admission"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata.0.name
    labels    = local.admission_labels
  }
  spec {
    port {
      app_protocol = "https"
      name         = "https-webhook"
      port         = 443
      target_port  = "webhook"
    }

    selector = {
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/instance"  = "ingress-nginx"
      "app.kubernetes.io/name"      = "ingress-nginx"
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_job_v1" "ingress_nginx_admission_create" {
  metadata {
    name      = "ingress-nginx-admission-create"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata.0.name
    labels    = local.admission_labels
  }
  spec {
    template {
      metadata {
        labels = local.admission_labels
        name   = "ingress-nginx-admission-create"
      }
      spec {
        container {
          args = [
            "create",
            "--host=ingress-nginx-controller-admission,ingress-nginx-controller-admission.$(POD_NAMESPACE).svc",
            "--namespace=$(POD_NAMESPACE)",
            "--secret-name=ingress-nginx-admission",
          ]
          env {
            name = "POD_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          image             = "registry.k8s.io/ingress-nginx/kube-webhook-certgen:v20231226-1a7112e06@sha256:25d6a5f11211cc5c3f9f2bf552b585374af287b4debf693cacbe2da47daa5084"
          image_pull_policy = "IfNotPresent"
          name              = "create"
          security_context {
            allow_privilege_escalation = false
            capabilities {
              drop = [
                "ALL",
              ]
            }
            read_only_root_filesystem = true
            run_as_non_root           = true
            run_as_user               = 65532
            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }
        node_selector = {
          "kubernetes.io/os" = "linux"
        }
        restart_policy       = "OnFailure"
        service_account_name = kubernetes_service_account_v1.ingress_nginx_admission.metadata.0.name
      }
    }
  }
  wait_for_completion = true
  timeouts {
    create = "120s"
  }
}

resource "kubernetes_job_v1" "ingress_nginx_admission_patch" {
  metadata {
    name      = "ingress-nginx-admission-patch"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata.0.name
    labels    = local.admission_labels
  }
  spec {
    template {
      metadata {
        labels = local.admission_labels
        name   = "ingress-nginx-admission-patch"

      }
      spec {
        container {
          args = [
            "patch",
            "--webhook-name=ingress-nginx-admission",
            "--namespace=$(POD_NAMESPACE)",
            "--patch-mutating=false",
            "--secret-name=ingress-nginx-admission",
            "--patch-failure-policy=Fail",
          ]
          env {
            name = "POD_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          image             = "registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.4.1@sha256:36d05b4077fb8e3d13663702fa337f124675ba8667cbd949c03a8e8ea6fa4366"
          image_pull_policy = "IfNotPresent"
          name              = "patch"
          security_context {
            allow_privilege_escalation = false
            capabilities {
              drop = [
                "ALL",
              ]
            }
            read_only_root_filesystem = true
            run_as_non_root           = true
            run_as_user               = 65532
            seccomp_profile {
              type = "RuntimeDefault"
            }
          }
        }
        node_selector = {
          "kubernetes.io/os" = "linux"
        }
        restart_policy       = "OnFailure"
        service_account_name = kubernetes_service_account_v1.ingress_nginx_admission.metadata.0.name
      }
    }
  }

  depends_on          = [kubernetes_job_v1.ingress_nginx_admission_create]
  wait_for_completion = true
  timeouts {
    create = "120s"
  }
}

resource "kubernetes_validating_webhook_configuration_v1" "ingress_nginx_admission" {
  metadata {
    labels = local.admission_labels
    name   = "ingress-nginx-admission"
  }
  webhook {
    admission_review_versions = ["v1"]
    client_config {
      service {
        name      = kubernetes_service_v1.ingress_nginx_controller_admission.metadata.0.name
        namespace = kubernetes_namespace_v1.ingress_nginx.metadata.0.name
        path      = "/networking/v1/ingresses"
      }
    }
    failure_policy = "Fail"
    match_policy   = "Equivalent"
    name           = "validate.nginx.ingress.kubernetes.io"
    rule {
      api_groups   = ["networking.k8s.io"]
      api_versions = ["v1"]
      operations   = ["CREATE", "UPDATE"]
      resources    = ["ingresses"]
    }
    side_effects = "None"
  }
}
