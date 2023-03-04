locals {
  domain             = "${var.brand_domain}${var.top_level_domain}"
  environment_domain = "${var.environment_name}.${local.domain}"
  app_domain         = "${var.app_name}.${local.environment_domain}"
  component_domain   = "${var.component_name}.${local.app_domain}"
}

resource "aws_route53_zone" "component_zone" {
  name = local.component_domain
  tags = var.tags
}

resource "aws_route53_record" "app_domain_ns" {
  zone_id = var.app_zone_id
  name    = local.component_domain
  type    = "NS"
  ttl     = "30"

  records = aws_route53_zone.component_zone.name_servers
}
