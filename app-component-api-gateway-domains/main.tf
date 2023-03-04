data "aws_region" "current" {}

locals {
  component_domain_name = "${var.component_name}.${var.app_name}.${var.environment_name}.${var.root_domain}"
  regional_domain_name  = "${data.aws_region.current.name}.${local.component_domain_name}"
  geo_domain_name       = "geo.${local.component_domain_name}"
}

resource "aws_api_gateway_domain_name" "regional_domain" {
  domain_name              = local.regional_domain_name
  regional_certificate_arn = var.certificate_arn
  security_policy          = "TLS_1_2"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_domain_name" "geo_domain" {
  domain_name              = local.geo_domain_name
  regional_certificate_arn = var.certificate_arn
  security_policy          = "TLS_1_2"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_domain_name" "api_domain" {
  domain_name              = local.component_domain_name
  regional_certificate_arn = var.certificate_arn
  security_policy          = "TLS_1_2"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_base_path_mapping" "regional_domain" {
  api_id      = var.api_gateway_id
  stage_name  = var.api_gateway_stage_name
  domain_name = aws_api_gateway_domain_name.regional_domain.domain_name
}

resource "aws_api_gateway_base_path_mapping" "geo_domain" {
  api_id      = var.api_gateway_id
  stage_name  = var.api_gateway_stage_name
  domain_name = aws_api_gateway_domain_name.geo_domain.domain_name
}

resource "aws_api_gateway_base_path_mapping" "api_domain" {
  api_id      = var.api_gateway_id
  stage_name  = var.api_gateway_stage_name
  domain_name = aws_api_gateway_domain_name.api_domain.domain_name
}
