locals {

  cluster_name = var.cluster_name

  variant = {
    for key, value in var.configuration :
    key => value.variant != null ? value.variant : local.default_variant
  }

  additional_resources = {
    for key, value in var.configuration :
    key => value.additional_resources != null ? value.additional_resources : []
  }

  # Flattened list for ids_prio[0]
  ids_prio_0 = flatten([
    for key, overlay in data.kustomization_overlay.current :
    [
      for id in overlay.ids_prio[0] :
      {
        key = key
        id  = id
      }
    ]
  ])

  # Flattened list for ids_prio[1]
  ids_prio_1 = flatten([
    for key, overlay in data.kustomization_overlay.current :
    [
      for id in overlay.ids_prio[1] :
      {
        key = key
        id  = id
      }
    ]
  ])

  # Flattened list for ids_prio[2]
  ids_prio_2 = flatten([
    for key, overlay in data.kustomization_overlay.current :
    [
      for id in overlay.ids_prio[2] :
      {
        key = key
        id  = id
      }
    ]
  ])

}
