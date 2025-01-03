locals {
  load_balancer = [
    for tg_key, tg_value in var.target_groups : {
      container_name   = module.label.id
      container_port   = tg_value.backend_port
      target_group_arn = module.alb.target_groups[tg_key].arn
    }
  ]

  security_group_rules = {
    for tg_key, tg_value in var.target_groups :
    "${tg_key}_alb_ingress" => {
      type                     = "ingress"
      from_port                = tg_value.backend_port
      to_port                  = tg_value.backend_port
      protocol                 = "tcp"
      description              = "Service port for ${tg_key}"
      source_security_group_id = module.alb.security_group_id
    }
  }

}
