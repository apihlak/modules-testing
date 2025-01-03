module "label" {
  source = "git::ssh://git@github.com/coingaming/infra-modules.git//modules/global/label?ref=main"

  context = module.this.context
}

data "aws_route53_zone" "main" {
  name = var.base_domain_name
}

resource "aws_route53_zone" "subdomain" {
  name = var.subdomain_name

  tags = module.label.tags
}

resource "aws_route53_record" "ns_record_subdomain" {
  type    = "NS"
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.subdomain_name
  ttl     = "300"
  records = aws_route53_zone.subdomain.name_servers
}

module "certificate" {
  # https://github.com/terraform-aws-modules/terraform-aws-acm
  source  = "terraform-aws-modules/acm/aws"
  version = "5.1.0"

  domain_name = "*.${var.subdomain_name}"

  zone_id                   = aws_route53_zone.subdomain.zone_id
  subject_alternative_names = var.subject_alternative_names
  validation_method         = "DNS"

  wait_for_validation = false

  tags = module.label.tags
}
