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

variable "tags" {
  type        = map
  description = ""
  default     = {}
}
