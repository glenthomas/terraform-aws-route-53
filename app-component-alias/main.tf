locals {
  environment_domain    = "${var.environment_name}.${var.root_domain}"
  app_domain            = "${var.app_name}.${local.environment_domain}"
  component_domain_name = "${var.component_name}.${local.app_domain}"
}

resource "aws_route53_record" "component_alias" {
  name    = local.component_domain_name
  type    = "A"
  zone_id = var.hosted_zone_id

  alias {
    evaluate_target_health = true
    name                   = var.alias_target_name
    zone_id                = var.alias_target_zone_id
  }
}
