module "label" {
  source = "git::ssh://git@github.com/coingaming/infra-modules.git//modules/global/label?ref=main"

  context = module.this.context

}

module "eks" {
  # https://github.com/terraform-aws-modules/terraform-aws-eks
  source  = "terraform-aws-modules/eks/aws"
  version = "20.23.0"

  # Name of the EKS cluster	
  cluster_name = module.label.id
  # Kubernetes <major>.<minor> version to use for the EKS cluster (i.e.: 1.27)
  # https://docs.aws.amazon.com/eks/latest/userguide/platform-versions.html
  cluster_version = var.cluster_version

  # Indicates whether or not the Amazon EKS public API server endpoint is enabled
  cluster_endpoint_public_access = true
  # List of CIDR blocks which can access the Amazon EKS public API server endpoint	
  cluster_endpoint_public_access_cidrs = local.cluster_endpoint_public_access_cidrs

  # Add the cluster creator as an administrator
  enable_cluster_creator_admin_permissions = true

  # Name to use on IAM role created. Keep IAM resource unique across regions
  iam_role_name = "${module.label.id}-role" # Backwards compat
  # Determines whether the IAM role name (iam_role_name) is used as a prefix
  iam_role_use_name_prefix = false # Backwards compat

  # ID of the VPC where the cluster security group will be provisioned	
  vpc_id = var.vpc_id

  # A list of subnet IDs where the nodes/node groups will be provisioned. If control_plane_subnet_ids is not provided, the EKS cluster control plane (ENIs) will be provisioned in these subnets	
  subnet_ids = var.private_subnets

  # Map of attribute maps for all EKS managed node groups created
  eks_managed_node_groups = local.managed_node_groups

  tags = module.label.tags

}

module "aws_auth" {
  # https://github.com/terraform-aws-modules/terraform-aws-eks/tree/master/modules/aws-auth
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "20.23.0"

  manage_aws_auth_configmap = true
  # Add AccountAdministrator role as administrator
  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.this.account_id}:role/AccountAdministrator"
      username = "AccountAdministrator"
      groups   = ["system:masters"]
    },
  ]

  depends_on = [module.eks.eks_managed_node_groups]
}

module "eks_blueprints_addons" {
  # https://github.com/aws-ia/terraform-aws-eks-blueprints-addons
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "1.1.1"

  # Name of the EKS cluster	
  cluster_name = module.eks.cluster_name
  # Endpoint for your Kubernetes API server	
  cluster_endpoint = module.eks.cluster_endpoint
  # Kubernetes <major>.<minor> version to use for the EKS cluster (i.e.: 1.24)
  cluster_version = module.eks.cluster_version
  # The ARN of the cluster OIDC Provider	
  oidc_provider_arn = module.eks.oidc_provider_arn

  # Map of EKS add-on configurations to enable for the cluster. Add-on name can be the map keys or set with name	
  eks_addons = var.eks_addons

  # Enable external-dns operator add-on	
  enable_external_dns = var.enable_external_dns
  # Module creates permission for accessing Route53 objects and the zone
  external_dns_route53_zone_arns = var.external_dns_route53_zone_arns
  # external-dns add-on configuration values	
  external_dns = {
    values = [
      "provider: aws",
      # Remove the record if Ingress is removed
      "policy: sync",
      # Add owner tag, Otherwise same record will be overwritten by other controller in different cluster
      "txtOwnerId: ${module.eks.cluster_name}"
    ]
  }

  # Enable AWS Load Balancer Controller add-on
  enable_aws_load_balancer_controller = var.enable_aws_load_balancer_controller

  # Enable Cluster Autoscaler controller add-on
  enable_cluster_autoscaler = var.enable_cluster_autoscaler

  # Enable External Secrets operator add-on
  enable_external_secrets = var.enable_external_secrets

  # Enable metrics server add-on
  enable_metrics_server = var.enable_metrics_server

  depends_on = [module.eks.eks_managed_node_groups]
  tags       = module.label.tags
}
