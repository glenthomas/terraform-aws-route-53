locals {
  environment_domain = "${var.environment_name}.${var.root_domain}"
  app_domain         = "${var.app_name}.${local.environment_domain}"
}

data "aws_route53_zone" "environment_zone" {
  provider = aws.environment_zone
  name     = "${local.environment_domain}."
}

resource "aws_route53_zone" "app_zone" {
  provider = aws.app_zone
  name     = local.app_domain
  tags     = var.tags
}

resource "aws_route53_record" "app_domain_ns" {
  provider = aws.environment_zone
  zone_id  = data.aws_route53_zone.environment_zone.zone_id
  name     = local.app_domain
  type     = "NS"
  ttl      = "30"

  records = aws_route53_zone.app_zone.name_servers
}
