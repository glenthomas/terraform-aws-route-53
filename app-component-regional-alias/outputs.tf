output component_domain_name {
  value = local.component_domain_name
}

output "component_regional_domain_name" {
  value = local.component_regional_domain_name
}

output "component_regional_alias_fqdn" {
  value = aws_route53_record.component_regional_alias.fqdn
}

output "component_latency_domain_name" {
  value = local.component_latency_domain_name
}

output "component_latency_alias_fqdn" {
  value = aws_route53_record.component_alias.fqdn
}

output hosted_zone_id {
  value = var.hosted_zone_id
}
