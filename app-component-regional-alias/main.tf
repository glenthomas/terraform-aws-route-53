locals {
  environment_domain             = "${var.environment_name}.${var.root_domain}"
  app_domain                     = "${var.app_name}.${local.environment_domain}"
  component_domain_name          = "${var.component_name}.${local.app_domain}"
  component_latency_domain_name  = "geo.${local.component_domain_name}"
  component_regional_domain_name = "${var.region_name}.${local.component_domain_name}"
}

resource "aws_route53_record" "component_alias" {
  name            = local.component_latency_domain_name
  type            = "A"
  zone_id         = var.hosted_zone_id
  set_identifier  = var.region_name
  health_check_id = var.health_check_id

  latency_routing_policy {
    region = var.region_name
  }

  alias {
    evaluate_target_health = true
    name                   = aws_route53_record.component_regional_alias.fqdn
    zone_id                = aws_route53_record.component_regional_alias.zone_id
  }
}

resource "aws_route53_record" "component_regional_alias" {
  name    = local.component_regional_domain_name
  type    = "A"
  zone_id = var.hosted_zone_id

  alias {
    evaluate_target_health = true
    name                   = var.alias_target_name
    zone_id                = var.alias_target_zone_id
  }
}
