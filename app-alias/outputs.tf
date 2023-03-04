output "app_domain_name" {
  value = local.app_domain
}

output "app_alias_fqdn" {
  value = aws_route53_record.app_alias.fqdn
}
