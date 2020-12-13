module "custom-booking-service" {
  source = "./modules/custom-node-service"

  enabled =  contains(local.services-enabled, "booking-service") ? "true" : "false"

  // HPA Config
  hpa-enabled        = contains(local.hpa-enabled-services, "booking-service") ? "true" : "false"
  metric             = "cpu"
  metric-utilization = 40
  max-replicas       = 8
  min-replicas       = 1


  // Kubernetes config
  svc-name        =  "custom-node-service"
  svc-version     =  local.project-versions["booking-service"]
  svc-port        =  local.booking-config["port"]
  container-image =  local.booking-config["container-image"]
  replicas        =  local.booking-config["replicas"]

  // RDS info
  rds-endpoint =  module.main-rds.endpoint
  rds-port     =  local.main-rds-config["port"]
  pg-user      =  local.main-rds-config["rds-user"]
  pg-pass      =  local.main-rds-config["rds-pass"]
  root-pg-user =  local.main-rds-config["root-user"]
  root-pg-pass =  local.main-rds-config["root-pass"]

  // Database jobs
  svc-databases       =  ["customnode"]
  rds-user-dependency =  module.rds-user-init-main.uid
  load-data           =  local.booking-config["load-data"]
  data-file-path      =  local.booking-config["data-file-path"]
  global-core-data-reset =  var.global-core-data-reset

  // Environment variables
  env-vars = {}
}