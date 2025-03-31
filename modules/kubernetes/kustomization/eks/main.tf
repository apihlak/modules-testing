module "label" {
  source = "git::ssh://git@github.com/coingaming/infra-modules.git?ref=modules/global/label/v1.0.0"
  context = module.this.context
}

module "kustomization" {
  source  = "git::ssh://git@github.com/coingaming/infra-modules.git?ref=modules/kubernetes/kustomization/generic/v1.0.0"

  # Kubernetes connection from data
  kubernetes_server = data.aws_eks_cluster.current.endpoint
  kubernetes_certificate_authority_data = data.aws_eks_cluster.current.certificate_authority[0].data
  kubernetes_token = data.aws_eks_cluster_auth.current.token

  # Label variables to pass generic
  name      = module.label.id
  namespace = module.label.namespace
  tags      = module.label.tags

  # Kustomization variables

  resources = var.resources
  additional_resources = var.additional_resources
  common_annotations = var.common_annotations
  common_labels = var.common_labels
  components = var.components
  helm_charts = var.helm_charts
  config_map_generator = var.config_map_generator
  crds = var.crds
  generators = var.generators
  generator_options = var.generator_options
  images = var.images
  name_prefix = var.name_prefix
  name_suffix = var.name_suffix
  patches = var.patches
  replicas = var.replicas
  secret_generator = var.secret_generator
  transformers = var.transformers
  vars = var.vars
  sensitive_group_kinds = var.sensitive_group_kinds
}
