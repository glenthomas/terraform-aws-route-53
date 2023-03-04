output "app_zone_id" {
  value = aws_route53_zone.app_zone.zone_id
}

output "app_domain_name" {
  value = local.app_domain
}

output "app_zone_name_servers" {
  value = aws_route53_zone.app_zone.name_servers
}
