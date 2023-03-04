output "component_zone_id" {
  value = aws_route53_zone.component_zone.zone_id
}

output "component_domain_name" {
  value = local.component_domain
}

output "component_zone_name_servers" {
  value = aws_route53_zone.component_zone.name_servers
}
