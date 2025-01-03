module "label" {
  source = "git::ssh://git@github.com/coingaming/infra-modules.git//modules/global/label?ref=main"

  context = module.this.context
}

provider "kustomization" {
  kubeconfig_raw = yamlencode(local.kubeconfig)
  context        = local.kubeconfig_context
}

data "aws_eks_cluster" "current" {
  name = local.cluster_name
}

data "aws_eks_cluster_auth" "current" {
  name = local.cluster_name
}

resource "kustomization_resource" "p0" {
  for_each = {
    for item in local.ids_prio_0 :
    "${item.key}-${item.id}" => item
  }

  # Access the manifest data using the key and ID
  manifest = (
    contains(var.sensitive_group_kinds, regex("(?P<group_kind>.*/.*)/.*/.*", each.value.id)["group_kind"])
    ? sensitive(data.kustomization_overlay.current[each.value.key].manifests[each.value.id])
    : data.kustomization_overlay.current[each.value.key].manifests[each.value.id]
  )
}

resource "kustomization_resource" "p1" {
  for_each = {
    for item in local.ids_prio_1 :
    "${item.key}-${item.id}" => item
  }

  # Access the manifest data using the key and ID
  manifest = (
    contains(var.sensitive_group_kinds, regex("(?P<group_kind>.*/.*)/.*/.*", each.value.id)["group_kind"])
    ? sensitive(data.kustomization_overlay.current[each.value.key].manifests[each.value.id])
    : data.kustomization_overlay.current[each.value.key].manifests[each.value.id]
  )

  depends_on = [kustomization_resource.p0]
}

resource "kustomization_resource" "p2" {
  for_each = {
    for item in local.ids_prio_2 :
    "${item.key}-${item.id}" => item
  }

  # Access the manifest data using the key and ID
  manifest = (
    contains(var.sensitive_group_kinds, regex("(?P<group_kind>.*/.*)/.*/.*", each.value.id)["group_kind"])
    ? sensitive(data.kustomization_overlay.current[each.value.key].manifests[each.value.id])
    : data.kustomization_overlay.current[each.value.key].manifests[each.value.id]
  )

  depends_on = [kustomization_resource.p1]
}
