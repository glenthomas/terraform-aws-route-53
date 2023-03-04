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

variable "certificate_arn" {
  type        = string
  description = ""
}

variable "api_gateway_id" {
  type        = string
  description = ""
}

variable "api_gateway_stage_name" {
  type        = string
  description = ""
}
