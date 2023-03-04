output "component_zone_id" {
  value = data.aws_route53_zone.component_zone.zone_id
}

output "component_domain_name" {
  value = local.component_domain
}

output "component_latency_domain_name" {
  value = "geo.${local.component_domain}"
}

output "component_zone_name_servers" {
  value = data.aws_route53_zone.component_zone.name_servers
}
