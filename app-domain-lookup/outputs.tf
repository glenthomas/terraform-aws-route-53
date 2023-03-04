output "app_zone_id" {
  value = data.aws_route53_zone.app_zone.zone_id
}

output "app_zone_name_servers" {
  value = data.aws_route53_zone.app_zone.name_servers
}
