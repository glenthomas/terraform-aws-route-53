locals {
  environment_domain = "${var.environment_name}.${var.root_domain}"
  app_domain         = "${var.app_name}.${local.environment_domain}"
  component_domain   = "${var.component_name}.${local.app_domain}"
}

data "aws_route53_zone" "component_zone" {
  name         = "${local.component_domain}."
  private_zone = var.private_zone
}
