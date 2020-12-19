variable "ingress-release-name" {
  type = string
}

variable "repository-url" {
  type    = string
}

variable "chart-name" {
  type    = string
}

variable "chart-version" {
  type    = string
}

variable "namespace" {
  type    = string
}

variable "max-history" {
  type    = string
  default = "3"
}

