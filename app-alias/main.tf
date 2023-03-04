locals {
  environment_domain = "${var.environment_name}.${var.root_domain}"
  app_domain         = "${var.app_name}.${local.environment_domain}"
}

resource "aws_route53_record" "app_alias" {
  name    = local.app_domain
  type    = "A"
  zone_id = var.hosted_zone_id

  alias {
    evaluate_target_health = true
    name                   = var.alias_target_name
    zone_id                = var.alias_target_zone_id
  }
}
