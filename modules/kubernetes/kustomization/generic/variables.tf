#     __ __      __
#    / //_/_  __/ /_  ___  _________  ___  ________  _____
#   / ,< / / / / __ \/ _ \/ ___/ __ \/ _ \/ ___/ _ \/ ___/
#  / /| / /_/ / /_/ /  __/ /  / / / /  __/ /  /  __(__  )
# /_/ |_\__,_/_.___/\___/_/  /_/ /_/\___/_/   \___/____/
#

variable "kubernetes_server" {
  type        = string
  description = "Kubernetes Server cluster name (endpoint)"
  default     = ""
}

variable "kubernetes_certificate_authority_data" {
  type        = string
  description = "The certificate authority data for the Kubernetes cluster."
  default     = ""
}

variable "kubernetes_token" {
  type        = string
  description = "The authentication token for the Kubernetes cluster."
  default     = ""
}

#     __ __           __                  _             __  _           
#    / //_/_  _______/ /_____  ____ ___  (_)___  ____ _/ /_(_)___  ____ 
#   / ,< / / / / ___/ __/ __ \/ __ `__ \/ /_  / / __ `/ __/ / __ \/ __ \
#  / /| / /_/ (__  ) /_/ /_/ / / / / / / / / /_/ /_/ / /_/ / /_/ / / / /
# /_/ |_\__,_/____/\__/\____/_/ /_/ /_/_/ /___/\__,_/\__/_/\____/_/ /_/ 
# 
 
variable "resources" {
  type        = list(string)
  description = "Will overwrite all of the module's upstream resources"
  default     = []
}

variable "additional_resources" {
  type        = list(string)
  description = "Concat additional resources to the list of included upstream resources"
  default     = []
}

variable "common_annotations" {
  type        = map(string)
  description = "Kustomization built-in annotations"
  default     = {}
}

variable "common_labels" {
  type        = map(string)
  description = "Kustomization built-in labels"
  default     = {}
}

variable "components" {
  type        = list(string)
  description = "Kustomization components"
  default     = []
}

variable "helm_charts" {
  type = list(object({
    name          = optional(string)
    version       = optional(string)
    repo          = optional(string)
    release_name  = optional(string)
    namespace     = optional(string)
    include_crds  = optional(bool)
    values_file   = optional(string)
    values_inline = optional(string)
    values_merge  = optional(string)
  }))
  description = "Helm charts configurations"
  default     = []
}

variable "config_map_generator" {
  type = list(object({
    name      = optional(string)
    namespace = optional(string)
    behavior  = optional(string)
    envs      = optional(list(string))
    files     = optional(list(string))
    literals  = optional(list(string))
    options = optional(object({
      labels                   = optional(map(string))
      annotations              = optional(map(string))
      disable_name_suffix_hash = optional(bool)
    }))
  }))
  description = "ConfigMap generator settings"
  default     = []
}

variable "crds" {
  type        = list(string)
  description = "Custom Resource Definitions"
  default     = []
}

variable "generators" {
  type        = list(string)
  description = "Generators configuration"
  default     = []
}

variable "generator_options" {
  type = list(object({
    labels                   = optional(map(string))
    annotations              = optional(map(string))
    disable_name_suffix_hash = optional(bool)
  }))
  description = "Generator options"
  default     = []
}

variable "images" {
  type = list(object({
    name     = optional(string)
    new_name = optional(string)
    new_tag  = optional(string)
    digest   = optional(string)
  }))
  description = "Image configurations"
  default     = []
}

variable "name_prefix" {
  type        = string
  description = "Prefix for naming conventions"
  default     = ""
}

variable "name_suffix" {
  type        = string
  description = "Suffix for naming conventions"
  default     = ""
}

variable "patches" {
  type = list(object({
    path  = optional(string)
    patch = optional(string)
    target = optional(object({
      group               = optional(string)
      version             = optional(string)
      kind                = optional(string)
      name                = optional(string)
      namespace           = optional(string)
      label_selector      = optional(string)
      annotation_selector = optional(string)
    }))
  }))
  description = "Patch configurations"
  default     = []
}

variable "replicas" {
  type = list(object({
    name  = optional(string)
    count = optional(number)
  }))
  description = "Replica configurations"
  default     = []
}

variable "secret_generator" {
  type = list(object({
    name      = optional(string)
    namespace = optional(string)
    behavior  = optional(string)
    type      = optional(string)
    envs      = optional(list(string))
    files     = optional(list(string))
    literals  = optional(list(string))
    options = optional(object({
      labels                   = optional(map(string))
      annotations              = optional(map(string))
      disable_name_suffix_hash = optional(bool)
    }))
  }))
  description = "Secret generator settings"
  default     = []
}

variable "transformers" {
  type        = list(string)
  description = "Transformers configuration"
  default     = []
}

variable "vars" {
  type = list(object({
    name    = optional(string)
    obj_ref = optional(object({
      api_version = optional(string)
      group       = optional(string)
      version     = optional(string)
      kind        = optional(string)
      name        = optional(string)
      namespace   = optional(string)
    }))
    field_ref = optional(object({
      field_path = optional(string)
    }))
  }))
  description = "Variable mappings"
  default     = []
}

variable "sensitive_group_kinds" {
  type        = list(string)
  description = "List of GroupKinds to mark sensitive. Defaults to [\"_/Secret\"]"
  default     = ["_/Secret"]
}
