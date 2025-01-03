module "label" {
  source = "git::ssh://git@github.com/coingaming/infra-modules.git//modules/global/label?ref=main"

  context = module.this.context
}

module "key_pair" {
  # https://github.com/terraform-aws-modules/terraform-aws-key-pair
  source  = "terraform-aws-modules/key-pair/aws"
  version = "2.0.3"

  create = var.create

  # Key name
  key_name = module.label.id

  # Input Public Key
  public_key = var.public_key

  tags = module.label.tags
}
