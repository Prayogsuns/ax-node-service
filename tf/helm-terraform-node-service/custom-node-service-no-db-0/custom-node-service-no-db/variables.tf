variable "enabled" {
  type    = string
  default = "true"
}

variable "svc-name" {
  type = string
}

variable "svc-port" {
  type = string
}

variable "replicas" {
  type    = string
  default = "3"
}

variable "container-image" {
  type = string
}

variable "svc-version" {
  type    = string
  default = "latest"
}

variable "env-vars" {
  type = map
}

variable "health-check-config" {
  type = any

  default = {}
}

