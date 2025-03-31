data "kustomization_overlay" "current" {

  common_annotations = var.common_annotations

  common_labels = merge(module.label.tags, var.common_labels)

  components = var.components

  kustomize_options {
    enable_helm = length(var.helm_charts) > 0 ? true : false
    helm_path   = "helm"
  }

  dynamic "helm_charts" {
    for_each = length(var.helm_charts) > 0 ? var.helm_charts : []

    content {
      name          = helm_charts.value["name"]
      version       = helm_charts.value["version"]
      repo          = helm_charts.value["repo"]
      release_name  = helm_charts.value["release_name"]
      namespace     = helm_charts.value["namespace"]
      include_crds  = helm_charts.value["include_crds"]
      values_inline = helm_charts.value["values_inline"]
      values_file   = helm_charts.value["values_file"]
      values_merge  = helm_charts.value["values_merge"]
    }
  }

  dynamic "config_map_generator" {
    for_each = length(var.config_map_generator) > 0 ? var.config_map_generator : []

    content {
      name      = config_map_generator.value["name"]
      namespace = config_map_generator.value["namespace"]
      behavior  = config_map_generator.value["behavior"]
      envs      = config_map_generator.value["envs"]
      files     = config_map_generator.value["files"]
      literals  = config_map_generator.value["literals"]
      options {
        labels                   = lookup(config_map_generator.value, "options") != null ? config_map_generator.value["options"]["labels"] : null
        annotations              = lookup(config_map_generator.value, "options") != null ? config_map_generator.value["options"]["annotations"] : null
        disable_name_suffix_hash = lookup(config_map_generator.value, "options") != null ? config_map_generator.value["options"]["disable_name_suffix_hash"] : null
      }
    }
  }

  crds = var.crds

  generators = var.generators

  dynamic "generator_options" {
    for_each = length(var.generator_options) > 0 ? var.generator_options : []

    content {
      labels                   = generator_options.value["labels"]
      annotations              = generator_options.value["annotations"]
      disable_name_suffix_hash = generator_options.value["disable_name_suffix_hash"]
    }
  }

  dynamic "images" {
    for_each = length(var.images) > 0 ? var.images : []

    content {
      name     = images.value["name"]
      new_name = images.value["new_name"]
      new_tag  = images.value["new_tag"]
      digest   = images.value["digest"]
    }
  }

  name_prefix = var.name_prefix

  namespace = var.namespace

  name_suffix = var.name_suffix

  dynamic "patches" {
    for_each = length(var.patches) > 0 ? var.patches : []

    content {
      path  = patches.value["path"]
      patch = patches.value["patch"]

      dynamic "target" {
        for_each = length(patches.value["target"]) > 0 ? toset([patches.value["target"]]) : toset([])

        content {
          group               = target.value["group"]
          version             = target.value["version"]
          kind                = target.value["kind"]
          name                = target.value["name"]
          namespace           = target.value["namespace"]
          label_selector      = target.value["label_selector"]
          annotation_selector = target.value["annotation_selector"]
        }
      }
    }
  }

  dynamic "replicas" {
    for_each = length(var.replicas) > 0 ? var.replicas : []

    content {
      name  = replicas.value["name"]
      count = replicas.value["count"]
    }
  }

  dynamic "secret_generator" {
    for_each = length(var.secret_generator) > 0 ? var.secret_generator : []

    content {
      name      = secret_generator.value["name"]
      namespace = secret_generator.value["namespace"]
      behavior  = secret_generator.value["behavior"]
      type      = secret_generator.value["type"]
      envs      = secret_generator.value["envs"]
      files     = secret_generator.value["files"]
      literals  = secret_generator.value["literals"]
      options {
        labels                   = lookup(secret_generator.value, "options") != null ? secret_generator.value["options"]["labels"] : null
        annotations              = lookup(secret_generator.value, "options") != null ? secret_generator.value["options"]["annotations"] : null
        disable_name_suffix_hash = lookup(secret_generator.value, "options") != null ? secret_generator.value["options"]["disable_name_suffix_hash"] : null
      }
    }
  }

  transformers = var.transformers

  dynamic "vars" {
    for_each = length(var.vars) > 0 ? var.vars : []

    content {
      name = vars.value["name"]
      obj_ref {
        api_version = lookup(vars.value, "obj_ref") != null ? vars.value["obj_ref"]["api_version"] : null
        group       = lookup(vars.value, "obj_ref") != null ? vars.value["obj_ref"]["group"] : null
        version     = lookup(vars.value, "obj_ref") != null ? vars.value["obj_ref"]["version"] : null
        kind        = lookup(vars.value, "obj_ref") != null ? vars.value["obj_ref"]["kind"] : null
        name        = lookup(vars.value, "obj_ref") != null ? vars.value["obj_ref"]["name"] : null
        namespace   = lookup(vars.value, "obj_ref") != null ? vars.value["obj_ref"]["namespace"] : null
      }
      field_ref {
        field_path = lookup(vars.value, "field_ref") != null ? vars.value["field_ref"]["field_path"] : null
      }
    }
  }

  resources = length(var.helm_charts) == 0 && length(var.resources) == 0 ? var.additional_resources : length(var.helm_charts) > 0 && length(var.resources) == 0 ? null : var.resources

}
