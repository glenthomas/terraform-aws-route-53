locals {
  environment_domain = "${var.environment_name}.${var.root_domain}"
  app_domain         = "${var.app_name}.${local.environment_domain}"
}

resource "aws_acm_certificate" "app_domain_certificate" {
  domain_name       = local.app_domain
  validation_method = "DNS"
  tags              = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "certificate_validation" {
  for_each = {
    for dvo in aws_acm_certificate.app_domain_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.app_zone_id
}

resource "aws_acm_certificate_validation" "component_domain_certificate" {
  count = replace(replace(var.wait_for_validation, "yes", "1"), "no", "0")

  certificate_arn         = aws_acm_certificate.app_domain_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.certificate_validation : record.fqdn]
}
