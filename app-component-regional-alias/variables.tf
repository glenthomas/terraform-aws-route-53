variable "root_domain" {
  type        = string
  description = "The domain and top level domain e.g. google.com"
}

variable "environment_name" {
  type        = string
  description = ""
}

variable "app_name" {
  type        = string
  description = ""
}

variable "component_name" {
  type        = string
  description = ""
}

variable "region_name" {
  type        = string
  description = ""
}

variable "alias_target_name" {
  type        = string
  description = ""
}

variable "alias_target_zone_id" {
  type        = string
  description = ""
}

variable "hosted_zone_id" {
  type        = string
  description = ""
}

variable "health_check_id" {
  description = "ID of Route 53 health check resource used to control regional alias"
  type        = string
  default     = null
}
