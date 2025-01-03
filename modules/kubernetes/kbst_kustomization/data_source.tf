# Define local variable to filter configurations based on 'enabled' property
locals {
  filtered_configuration = {
    for k, v in var.configuration : k => v
    if !contains(keys(v), "enabled") || v.enabled == true
  }
}

data "kustomization_overlay" "current" {
  for_each = local.filtered_configuration

  common_annotations = each.value.common_annotations

  common_labels = merge(module.label.tags, each.value.common_labels)

  components = each.value.components

  kustomize_options {
    enable_helm = each.value.helm_charts != null ? true : false
    helm_path   = "helm"
  }

  dynamic "helm_charts" {
    for_each = each.value.helm_charts != null ? each.value.helm_charts : []
    iterator = i

    content {
      name          = i.value["name"]
      version       = i.value["version"]
      repo          = i.value["repo"]
      release_name  = i.value["release_name"]
      namespace     = i.value["namespace"]
      include_crds  = i.value["include_crds"]
      values_inline = i.value["values_inline"]
      values_file   = i.value["values_file"]
      values_merge  = i.value["values_merge"]
    }
  }

  dynamic "config_map_generator" {
    for_each = each.value.config_map_generator != null ? each.value.config_map_generator : []
    iterator = i
    content {
      name      = i.value["name"]
      namespace = i.value["namespace"]
      behavior  = i.value["behavior"]
      envs      = i.value["envs"]
      files     = i.value["files"]
      literals  = i.value["literals"]
      options {
        labels                   = lookup(i.value, "options") != null ? i.value["options"]["labels"] : null
        annotations              = lookup(i.value, "options") != null ? i.value["options"]["annotations"] : null
        disable_name_suffix_hash = lookup(i.value, "options") != null ? i.value["options"]["disable_name_suffix_hash"] : null
      }
    }
  }

  crds = each.value.crds

  generators = each.value.generators

  dynamic "generator_options" {
    for_each = each.value.generator_options != null ? [each.value.generator_options] : []
    iterator = i
    content {
      labels                   = i.value["labels"]
      annotations              = i.value["annotations"]
      disable_name_suffix_hash = i.value["disable_name_suffix_hash"]
    }
  }

  dynamic "images" {
    for_each = lookup(each.value, "images") != null ? lookup(each.value, "images") : []
    iterator = i
    content {
      name     = i.value["name"]
      new_name = i.value["new_name"]
      new_tag  = i.value["new_tag"]
      digest   = i.value["digest"]
    }
  }

  name_prefix = each.value.name_prefix

  namespace = each.value.namespace

  name_suffix = each.value.name_suffix

  dynamic "patches" {
    for_each = each.value.patches != null ? each.value.patches : []
    iterator = i
    content {
      path  = i.value["path"]
      patch = i.value["patch"]

      dynamic "target" {
        for_each = i.value["target"] != null ? toset([i.value["target"]]) : toset([])
        iterator = j
        content {
          group               = j.value["group"]
          version             = j.value["version"]
          kind                = j.value["kind"]
          name                = j.value["name"]
          namespace           = j.value["namespace"]
          label_selector      = j.value["label_selector"]
          annotation_selector = j.value["annotation_selector"]
        }
      }
    }
  }

  dynamic "replicas" {
    for_each = each.value.replicas != null ? each.value.replicas : []
    iterator = i
    content {
      name  = i.value["name"]
      count = i.value["count"]
    }
  }

  dynamic "secret_generator" {
    for_each = each.value.secret_generator != null ? each.value.secret_generator : []
    iterator = i
    content {
      name      = i.value["name"]
      namespace = i.value["namespace"]
      behavior  = i.value["behavior"]
      type      = i.value["type"]
      envs      = i.value["envs"]
      files     = i.value["files"]
      literals  = i.value["literals"]
      options {
        labels                   = lookup(i.value, "options") != null ? i.value["options"]["labels"] : null
        annotations              = lookup(i.value, "options") != null ? i.value["options"]["annotations"] : null
        disable_name_suffix_hash = lookup(i.value, "options") != null ? i.value["options"]["disable_name_suffix_hash"] : null
      }
    }
  }

  transformers = each.value.transformers

  dynamic "vars" {
    for_each = each.value.vars != null ? each.value.vars : []
    iterator = i
    content {
      name = i.value["name"]
      obj_ref {
        api_version = lookup(i.value, "obj_ref") != null ? i.value["obj_ref"]["api_version"] : null
        group       = lookup(i.value, "obj_ref") != null ? i.value["obj_ref"]["group"] : null
        version     = lookup(i.value, "obj_ref") != null ? i.value["obj_ref"]["version"] : null
        kind        = lookup(i.value, "obj_ref") != null ? i.value["obj_ref"]["kind"] : null
        name        = lookup(i.value, "obj_ref") != null ? i.value["obj_ref"]["name"] : null
        namespace   = lookup(i.value, "obj_ref") != null ? i.value["obj_ref"]["namespace"] : null
      }
      field_ref {
        field_path = lookup(i.value, "field_ref") != null ? i.value["field_ref"]["field_path"] : null
      }
    }
  }

  resources = each.value.helm_charts == null && each.value.resources == null ? concat(["${local.variant[each.key]}/"], local.additional_resources[each.key]) : each.value.helm_charts != null && each.value.resources == null ? null : each.value.resources

}
