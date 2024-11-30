# Creates a Namespace
resource "kubernetes_namespace_v1" "workshop" {
  metadata {
    name = "workshop"
    labels = {
      istio-injection = "enabled"
    }
  }

  depends_on = [module.istio]
}

# Deploys the Helm Chart
# Options can be found here: https://artifacthub.io/packages/helm/nextcloud/nextcloud
resource "helm_release" "nextcloud" {
  name       = "nextcloud"
  chart      = "nextcloud"
  repository = "https://nextcloud.github.io/helm/"
  version    = "6.2.4"
  namespace  = kubernetes_namespace_v1.workshop.metadata[0].name
  lint       = true
  atomic     = true
  wait       = true
}

#resource "kubernetes_manifest" "virtualservice" {
#  manifest = {
#    "apiVersion" = "networking.istio.io/v1"
#    "kind"       = "VirtualService"
#    "metadata" = {
#      "name"      = "nextcloud"
#      "namespace" = "${kubernetes_namespace_v1.workshop.metadata[0].name}"
#    }
#    "spec" = {
#      "hosts"    = ["ingress.local"]
#      "gateways" = ["nextcloud-gateway"]
#      "http" = [
#        {
#          "match" = [
#            {
#              "uri" = {
#                "prefix" = "/"
#              }
#            }
#          ]
#          "route" = [
#            {
#              "destination" = {
#                "port" = {
#                  "number" = "80"
#                }
#                "host" = "nextcloud"
#              }
#            }
#          ]
#        }
#      ]
#    }
#  }
#  depends_on = [helm_release.nextcloud]
#  wait {
#     condition {
#        status = "Deployed"
#        type = "Available"
#     }
#  }
#}
#
## Creates an Ingress Instance for nextcloud
#resource "kubernetes_manifest" "gateway" {
#  manifest = {
#    "apiVersion" = "networking.istio.io/v1"
#    "kind"       = "Gateway"
#    "metadata" = {
#      "name"      = "nextcloud-gateway"
#      "namespace" = "${kubernetes_namespace_v1.workshop.metadata[0].name}"
#    }
#    "spec" = {
#      "selector" = {
#        "istio" = "ingressgateway"
#      }
#      "servers" = [
#        {
#          "port" = {
#            "number"   = "80"
#            "name"     = "http"
#            "protocol" = "HTTP"
#          }
#          "hosts" = ["ingress.local"]
#        }
#      ]
#    }
#  }
#  depends_on = [helm_release.nextcloud]
#  wait {
#     condition {
#        status = "Deployed"
#        type = "Available"
#     }
#  }
#}
#