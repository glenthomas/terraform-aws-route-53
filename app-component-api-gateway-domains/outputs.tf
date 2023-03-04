output "api_gateway_regional_domain_name" {
  value = aws_api_gateway_domain_name.regional_domain.regional_domain_name
}

output "api_gateway_regional_zone_id" {
  value = aws_api_gateway_domain_name.regional_domain.regional_zone_id
}
