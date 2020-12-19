variable "enabled" {
  type    = string
  default = "true"
}

variable "namespace" {
  type    = string
  default = "default"
}

variable "max-history" {
  type    = string
  default = "3"
}

variable "svc-name" {
  type = string
}

variable "svc-port" {
  type = string
}

variable "svc-type" {
  type = string
  default = "ClusterIP"
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

variable "ingress-annotations" {
  type = map
  default = {}
}

variable "ingress-rules" {
  type = list
}

variable "hpa-enabled" {
  type = string
  default = "false"
}

variable "metric" {
  type = string
}

variable "metric-utilization" {
   type = string
}

variable "max-replicas" {
  type = string
}

variable "min-replicas" {
   type = string
}

