variable domain_name {
  description = "The fully qualified domain name of the endpoint to be checked."
  type        = string
}

variable port {
  description = "The port of the endpoint to be checked."
  type        = number
  default     = 443
}

variable resource_path {
  description = "The path that you want Amazon Route 53 to request when performing health checks."
  type        = string
  default     = "/health"
}

variable request_interval {
  description = "The number of seconds between the time that Amazon Route 53 gets a response from your endpoint and the time that it sends the next health-check request. 10 or 30."
  type        = number
  default     = 10
}

variable failure_threshold {
  description = "The number of consecutive health checks that an endpoint must pass or fail to switch status."
  type        = number
  default     = 3
}

variable disabled {
  description = "Stops submitting health check requests to your application"
  type = bool
  default = false
}

variable alarm_name {
  description = "A prefix for the name of the CloudWatch alarms"
  type        = string
}

variable alarm_topic_arn {
  description = "The ARN of an SNS topic to send alarm notifications to."
  type        = string
  default     = ""
}

variable tags {
  type    = map(string)
  default = {}
}
