module "label" {
  source = "git::ssh://git@github.com/coingaming/infra-modules.git//modules/global/label?ref=main"

  id_length_limit = 32

  context = module.this.context

}

module "ecs_service" {
  # https://github.com/terraform-aws-modules/terraform-aws-ecs/tree/master/modules/service
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "5.12.0"

  create = var.create

  # ECS Service Name
  name = module.label.id
  # ECS Cluster ARN
  cluster_arn = var.cluster_arn

  load_balancer = local.load_balancer

  # Subnet IDs
  subnet_ids = var.service_subnets

  capacity_provider_strategy = {
    capacity_provider = {
      capacity_provider = var.capacity_provider_name
      weight            = var.capacity_provider_weight
      base              = var.capacity_provider_base
    }
  }

  requires_compatibilities = var.requires_compatibilities
  network_mode             = var.network_mode
  memory                   = var.memory
  cpu                      = var.cpu

  # https://github.com/terraform-aws-modules/terraform-aws-ecs/blob/master/modules/container-definition/variables.tf

  container_definitions = {
    "${module.label.id}" = {
      image                                  = var.image
      memory                                 = var.memory
      memory_reservation                     = var.memory_reservation
      cpu                                    = var.cpu
      port_mappings                          = var.port_mappings
      environment                            = var.env
      secrets                                = var.secrets
      readonly_root_filesystem               = var.readonly_root_filesystem
      enable_cloudwatch_logging              = true
      create_cloudwatch_log_group            = true
      cloudwatch_log_group_retention_in_days = var.cloudwatch_log_group_retention_in_days
      log_configuration                      = var.log_configuration
    }
  }

  # Security Group
  security_group_name            = "${module.label.id}-sg-service"
  security_group_use_name_prefix = false
  security_group_description     = "Service security group for ${module.label.id}"
  security_group_rules           = local.security_group_rules

  tags = module.label.tags

}

module "alb" {
  # https://github.com/terraform-aws-modules/terraform-aws-alb
  source  = "terraform-aws-modules/alb/aws"
  version = "9.12.0"

  create = var.create

  name = module.label.id

  load_balancer_type = var.load_balancer_type

  vpc_id = var.vpc_id

  subnets = var.alb_subnets

  enable_deletion_protection = false

  # Security Group
  security_group_name            = "${module.label.id}-sg-alb"
  security_group_use_name_prefix = false
  security_group_description     = "Load Balancer security group for ${module.label.id}"

  security_group_ingress_rules = var.security_group_ingress_rules
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = var.vpc_cidr
    }
  }

  listeners     = var.listeners
  target_groups = var.target_groups

  tags = module.label.tags
}
