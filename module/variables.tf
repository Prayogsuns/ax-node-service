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

variable "rds-db-migrate-uids" {
  type = string
  default = ""
}

variable "container-image" {
  type = string
}

variable "svc-version" {
  type    = string
  default = "latest"
}

variable "health-check-config" {
  type = any

  default = {}
}

variable "env-vars" {
  type = map
  default = {}
}

variable "ingress-annotations" {
  type = map
  default = {}
}

variable "ingress-rules" {
  type = list
  default = []
}

variable "hpa-enabled" {
  type = string
  default = "false"
}

variable "metric" {
  type = string
  default = "cpu"
}

variable "metric-utilization" {
   type = string
   default = "50"
}

variable "max-replicas" {
  type = string
  default = "3"
}

variable "min-replicas" {
   type = string
   default = "1"
}
