variable "root_domain" {
  type        = string
  description = "The domain and top level domain e.g. google.com"
}

variable "app_name" {
  type        = string
  description = ""
}

variable "environment_name" {
  type        = string
  description = ""
}

variable "component_name" {
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
