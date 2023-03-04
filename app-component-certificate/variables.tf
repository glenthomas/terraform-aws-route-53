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

variable "app_zone_id" {
  type        = string
  description = ""
}

variable "component_zone_id" {
  type        = string
  description = ""
}

variable "wait_for_validation" {
  type        = string
  description = ""
}

variable "tags" {
  type = map
}
