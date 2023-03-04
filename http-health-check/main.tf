data "aws_region" "current" {}

locals {
  health_check_default_tags = {
    Name = var.domain_name
  }
}

provider "aws" {
  alias = "current_region"
}

provider "aws" {
  alias = "us_east_1"
}

resource "aws_route53_health_check" "http" {
  provider          = aws.current_region
  fqdn              = var.domain_name
  port              = var.port
  type              = "HTTPS"
  resource_path     = var.resource_path
  failure_threshold = var.failure_threshold
  request_interval  = var.request_interval
  regions = [
    "eu-west-1",
    "us-east-1",
    "ap-southeast-2"
  ]
  disabled = var.disabled
  tags     = merge(var.tags, local.health_check_default_tags)
}

locals {
  alarm_action_arns = length(var.alarm_topic_arn) > 0 ? [var.alarm_topic_arn] : []
}

resource "aws_cloudwatch_metric_alarm" "http_healthcheck_status" {
  provider            = aws.us_east_1
  alarm_name          = "${var.alarm_name}-${data.aws_region.current.name}-unhealthy"
  alarm_description   = "${data.aws_region.current.name} HTTP healthcheck is unhealthy at https://${var.domain_name}:${var.port}${var.resource_path}."
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthCheckStatus"
  namespace           = "AWS/Route53"
  period              = var.failure_threshold * var.request_interval * 2
  statistic           = "Minimum"
  threshold           = "0"
  treat_missing_data  = "ignore"
  alarm_actions       = local.alarm_action_arns
  ok_actions          = local.alarm_action_arns
  dimensions = {
    HealthCheckId = aws_route53_health_check.http.id
  }
  tags = var.tags
}
