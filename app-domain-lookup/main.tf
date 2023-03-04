locals {
  environment_domain = "${var.environment_name}.${var.root_domain}"
  app_domain         = "${var.app_name}.${local.environment_domain}"
}

data "aws_route53_zone" "app_zone" {
  name         = "${local.app_domain}."
  private_zone = var.private_zone
}
