data "external" "cluster-info" {
  program = ["${path.root}/scripts/get-cluster-info.sh"]
}

data "aws_security_group" "node-sg" {
  name = "nodes.${data.external.cluster-info.result["cluster-name"]}"
}

data "aws_autoscaling_groups" "node-asg" {
  filter {
    name   = "auto-scaling-group"
    values = ["nodes.${data.external.cluster-info.result["cluster-name"]}"]
  }
}

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

variable "rds-endpoint" {
  type = string
}

variable "rds-port" {
  type    = string
  default = "5432"
}

variable "pg-user" {
  type = string
}

variable "pg-pass" {
  type = string
}

variable "root-pg-user" {
  type = string
}

variable "root-pg-pass" {
  type = string
}

variable "svc-databases" {
  type = list
}

variable "load-data" {
  type    = string
  default = "false"
}

variable "global-core-data-reset" {
  type    = string
  default = "false"
}


variable "data-file-path" {
  type    = string
  default = ""
}

variable "db-dump-npm-command" {
  type    = string
  default = "prep-database"
}

variable "db-force-recreate" {
  type    = string
  default = "false"
}

variable "rds-user-dependency" {
  type    = string
  default = ""
}

variable "health-check-config" {
  type = any

  default = {}
}

variable "env-vars" {
  type = map
}

variable "load-balancer-arn" {
  type    = string
  default = ""
}

variable "hpa-enabled" {
  type = string
  default = ""
}

variable "metric" {
  type = string
  default = ""
}

variable "metric-utilization" {
   type = string
   default = ""
}

variable "max-replicas" {
  type = string
  default = ""
}

variable "min-replicas" {
   type = string
   default = ""
}


