# Config for Kubernetes connection
locals {
  # non-default context name to protect from using wrong kubeconfig
  kubeconfig_context = "_terraform-kustomization-${var.kubernetes_server}_"

  kubeconfig = {
    apiVersion = "v1"
    clusters = [
      {
        name = local.kubeconfig_context
        cluster = {
          certificate-authority-data = var.kubernetes_certificate_authority_data
          server                     = var.kubernetes_server
        }
      }
    ]
    users = [
      {
        name = local.kubeconfig_context
        user = {
          token = var.kubernetes_token
        }
      }
    ]
    contexts = [
      {
        name = local.kubeconfig_context
        context = {
          cluster = local.kubeconfig_context
          user    = local.kubeconfig_context
        }
      }
    ]
  }
}
