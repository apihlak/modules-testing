module "label" {
  source = "git::ssh://git@github.com/coingaming/infra-modules.git?ref=modules/global/label/v1.0.0"
  context = module.this.context
}

provider "kustomization" {
  kubeconfig_raw = yamlencode(local.kubeconfig)
  context        = local.kubeconfig_context
}

# P0 of the ids
resource "kustomization_resource" "p0_non_sensitive" {
  for_each = {
    for item in data.kustomization_overlay.current.ids_prio[0] :
    item => item
    if !contains(var.sensitive_group_kinds, try(regex("(?P<group_kind>.*/.*)/.*/.*", item)["group_kind"], null))
  }
  manifest = data.kustomization_overlay.current.manifests[each.value]
}

resource "kustomization_resource" "p0_sensitive" {
  for_each = {
    for item in data.kustomization_overlay.current.ids_prio[0] :
    item => item
    if contains(var.sensitive_group_kinds, try(regex("(?P<group_kind>.*/.*)/.*/.*", item)["group_kind"], null))
  }
  manifest = sensitive(data.kustomization_overlay.current.manifests[each.value])
}

# P1 of the ids
resource "kustomization_resource" "p1_non_sensitive" {
  for_each = {
    for item in data.kustomization_overlay.current.ids_prio[1] :
    item => item
    if !contains(var.sensitive_group_kinds, try(regex("(?P<group_kind>.*/.*)/.*/.*", item)["group_kind"], null))
  }
  manifest = data.kustomization_overlay.current.manifests[each.value]
  depends_on = [
    kustomization_resource.p0_sensitive,
    kustomization_resource.p0_non_sensitive,
  ]
}

resource "kustomization_resource" "p1_sensitive" {
  for_each = {
    for item in data.kustomization_overlay.current.ids_prio[1] :
    item => item
    if contains(var.sensitive_group_kinds, try(regex("(?P<group_kind>.*/.*)/.*/.*", item)["group_kind"], null))
  }
  manifest = sensitive(data.kustomization_overlay.current.manifests[each.value])
  depends_on = [
    kustomization_resource.p0_sensitive,
    kustomization_resource.p0_non_sensitive,
  ]
}

# P2 of the ids
resource "kustomization_resource" "p2_non_sensitive" {
  for_each = {
    for item in data.kustomization_overlay.current.ids_prio[2] :
    item => item
    if !contains(var.sensitive_group_kinds, try(regex("(?P<group_kind>.*/.*)/.*/.*", item)["group_kind"], null))
  }
  manifest = data.kustomization_overlay.current.manifests[each.value]
  depends_on = [
    kustomization_resource.p1_sensitive,
    kustomization_resource.p1_non_sensitive,
  ]
}

resource "kustomization_resource" "p2_sensitive" {
  for_each = {
    for item in data.kustomization_overlay.current.ids_prio[2] :
    item => item
    if contains(var.sensitive_group_kinds, try(regex("(?P<group_kind>.*/.*)/.*/.*", item)["group_kind"], null))
  }
  manifest = sensitive(data.kustomization_overlay.current.manifests[each.value])
  depends_on = [
    kustomization_resource.p1_sensitive,
    kustomization_resource.p1_non_sensitive,
  ]
}
