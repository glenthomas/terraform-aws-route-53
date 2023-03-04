output "component_domain_name" {
  value = local.component_domain_name
}

output "component_alias_fqdn" {
  value = aws_route53_record.component_alias.fqdn
}
