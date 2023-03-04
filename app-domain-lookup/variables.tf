variable "root_domain" {
  type        = string
  description = "The domain and top level domain e.g. google.com"
}

variable "app_name" {
  type = string
}

variable "environment_name" {
  type = string
}

variable "private_zone" {
  type    = bool
  default = false
}
