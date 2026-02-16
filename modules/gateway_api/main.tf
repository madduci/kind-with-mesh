locals {
  gateway_api_url = "https://github.com/kubernetes-sigs/gateway-api/releases/download/${var.release_version}/standard-install.yaml"
}

resource "null_resource" "gateway_api_deploy" {
  triggers = {
    on_version_change = var.release_version
    gateway_api_url   = local.gateway_api_url
    kubeconfig_path   = var.kubeconfig_path
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${local.gateway_api_url} --kubeconfig=${var.kubeconfig_path}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "kubectl delete -f ${self.triggers.gateway_api_url} --kubeconfig=${self.triggers.kubeconfig_path} --ignore-not-found=true"
  }
}
