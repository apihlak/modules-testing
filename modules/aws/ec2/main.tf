module "label" {
  source = "git::ssh://git@github.com/coingaming/infra-modules.git//modules/global/label?ref=main"

  context = module.this.context
}

module "ec2_instance" {
  # https://github.com/terraform-aws-modules/terraform-aws-ec2-instance
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.7.1"

  create = var.create

  name = module.label.id

  # Instance Type
  instance_type = var.instance_type

  # Instance Operating System
  ami = data.aws_ami.ubuntu.id

  # Create static Public IPv4 address
  create_eip = var.create_eip

  # Initial Security Group
  vpc_security_group_ids = [module.security_group.security_group_id]

  # SSH key name
  key_name = var.key_name

  # Subnet where EC2 instance will be created
  subnet_id = var.subnet_id

  tags = module.label.tags
}

module "security_group" {
  # https://github.com/terraform-aws-modules/terraform-aws-security-group
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.2.0"

  create = var.create

  name            = "${module.label.id}-ec2-sg"
  use_name_prefix = false
  description     = "EC2 security group for ${module.label.id}"

  # where to create security group
  vpc_id = var.vpc_id

  # CIDR range to use on all ingress rules
  ingress_cidr_blocks = concat(
    module.zt_whitelist.cloudflare_egress_ipv4, # Give access to Cloudflare ZT static egress ipv4 addresses
    var.ingress_cidr_blocks,
  )

  # Default allow SSH and Load Balancer incoming
  ingress_rules = var.ingress_rules

  # Default allow all outgoing
  egress_rules = var.egress_rules

  tags = module.label.tags
}

