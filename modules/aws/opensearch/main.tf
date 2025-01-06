#### TEST
module "label" {
  source = "git::ssh://git@github.com/coingaming/infra-modules.git//modules/global/label?ref=main"

  # Opensearch domain_name (must start with a lowercase alphabet and be at least 3 and no more than 28 characters long
  id_length_limit = 28

  context = module.this.context
}

module "opensearch" {
  # https://github.com/terraform-aws-modules/terraform-aws-opensearch
  source  = "terraform-aws-modules/opensearch/aws"
  version = "1.4.0"

  # Name of the domain
  domain_name = module.label.id

  # Version of the OpenSearch engine to use
  engine_version = var.engine_version

  # Configuration block for the cluster of the domain	
  cluster_config = var.cluster_config

  # Configuration block for EBS related options
  ebs_options = var.ebs_options

  # A map of IAM policy statements for custom permission usage	
  access_policy_statements = var.access_policy_statements

  # Configuration block for fine-grained access control	
  advanced_security_options = var.advanced_security_options

  # Security group ingress and egress rules to add to the security group created	
  security_group_rules = var.security_group_rules

  # Auto-Tune settings when updating a domain
  auto_tune_options = var.auto_tune_options

  # Log publishing options
  log_publishing_options = var.log_publishing_options

  # Configuration block for VPC related option
  vpc_options = var.vpc_options

  # VPC endpoint
  vpc_endpoints = var.vpc_endpoints

  tags = module.label.tags
}

# Authorize access to Opensearch if more than one element is defined in vpc_endpoint_accounts_to_authorize
resource "aws_opensearch_authorize_vpc_endpoint_access" "current" {
  for_each    = length(var.vpc_endpoint_accounts_to_authorize) > 0 ? toset(var.vpc_endpoint_accounts_to_authorize) : toset([])
  domain_name = module.label.id
  account     = each.key

  depends_on = [module.opensearch]

}
