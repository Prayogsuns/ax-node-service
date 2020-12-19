module "custom-booking-service" {
  source = "./modules/custom-node-service"

  // enabled =  contains(local.services-enabled, "booking-service") ? "true" : "false"
  enabled = "true"

  // HPA Config
  // hpa-enabled        = contains(local.hpa-enabled-services, "booking-service") ? "true" : "false"
  hpa-enabled        = "true"
  metric             = "cpu"
  metric-utilization = 40
  max-replicas       = 8
  min-replicas       = 1

  // Kubernetes config
  namespace       =  "default"
  svc-name        =  "custom-booking-service"
  svc-version     =  local.project-versions["booking-service"]
  svc-port        =  local.booking-config["port"]
  svc-type        =  "ClusterIP"
  container-image =  local.booking-config["container-image"]
  replicas        =  local.booking-config["replicas"]

  ingress-annotations = {
    "kubernetes.io/ingress.class"               = "nginx"
  }

  ingress-rules = [{
    http = {
      paths = [{
        backend = {
          serviceName = "custom-booking-service"
          servicePort = local.booking-config["port"]
        }
        path = "/booking"
      }]
    }
  }]


  node-svc-db-enabled    =  "true"

  // RDS info
  rds-endpoint =  module.main-rds.endpoint
  rds-port     =  local.main-rds-config["port"]
  pg-user      =  local.main-rds-config["rds-user"]
  pg-pass      =  local.main-rds-config["rds-pass"]
  root-pg-user =  local.main-rds-config["root-user"]
  root-pg-pass =  local.main-rds-config["root-pass"]

  // Database jobs
  svc-databases       =  ["db-create-custom-booking"]
  rds-user-dependency =  module.rds-user-init-main.uid
  load-data           =  local.booking-config["load-data"]
  data-file-path      =  local.booking-config["data-file-path"]
  global-core-data-reset =  var.global-core-data-reset

  // Health check
  health-check-config = {
    initialDelaySeconds  = 5
    periodSeconds        = 30
    successThreshold     = 1
    timeoutSeconds       = 10

    httpGet = {
      path = "/health"
      port =  local.booking-config["port"]
    }
  }

  // Environment variables
  env-vars = {
    BOOKING_SERVICE_DATABASE_USER           =  local.main-rds-config["rds-user"]
    BOOKING_SERVICE_DATABASE_PASS           =  local.main-rds-config["rds-pass"]
    BOOKING_SERVICE_DATABASE_OPTIONS_HOST   =  module.main-rds.endpoint
    BOOKING_SERVICE_DATABASE_OPTIONS_PORT   =  local.main-rds-config["port"]
    BOOKING_SERVICE_DS_API_HOSTNAME         =  "${local.dispatch-config["name"]}.default.svc.cluster.local."
    BOOKING_SERVICE_DS_API_PORT             =  local.dispatch-config["port"]
    BOOKING_SERVICE_SS_HOSTNAME             =  "${local.scheduling-config["name"]}.default.svc.cluster.local."
    BOOKING_SERVICE_SS_PORT                 =  local.scheduling-config["port"]
    BOOKING_SERVICE_API_SWAGGER_HOST        =  "${local.api-gateway-config["subdomain"]}.${data.external.cluster-info.result["cluster-name"]}"
    BOOKING_SERVICE_API_SWAGGER_BASE_PATH   = "/booking"
    BOOKING_SERVICE_API_SWAGGER_UI_BASE_URL = "https://${local.api-gateway-config["subdomain"]}.${data.external.cluster-info.result["cluster-name"]}/booking"
    BOOKING_SERVICE_API_SWAGGER_SCHEMES     = "[\"https\"]"
    LOGGING_DAILYROTATEFILE_SILENT          = "true"
    CONFIG_SERVICE_HOST                     =  "${local.config-service-config["name"]}.default.svc.cluster.local."
    CONFIG_SERVICE_PORT                     =  local.config-service-config["port"]
    RIDER_MANAGEMENT_SERVICE_HOST           =  "${local.rms-config["name"]}.default.svc.cluster.local."
    RIDER_MANAGEMENT_SERVICE_PORT           =  local.rms-config["port"]
    ADDRESS_SERVICE_ENABLED                 =  contains(local.services-enabled, "address-service") ? local.booking-config["address-service-enabled"] : "false"
    ADDRESS_SERVICE_HOST                    =  "${local.address-config["name"]}.default.svc.cluster.local."
    ADDRESS_SERVICE_PORT                    =  local.address-config["port"]
    TIMEZONE                                =  local.site-config["timezone"]
  }
}

module "v2-custom-booking-service" {
  source = "./modules/custom-node-service"

  // enabled =  contains(local.services-enabled, "booking-service") ? "true" : "false"
  enabled = "true"

  // HPA Config
  // hpa-enabled        = contains(local.hpa-enabled-services, "booking-service") ? "true" : "false"
  hpa-enabled        = "true"
  metric             = "cpu"
  metric-utilization = 40
  max-replicas       = 8
  min-replicas       = 1

  // Kubernetes config
  namespace       =  "default"
  svc-name        =  "v2-custom-booking-service"
  svc-version     =  local.project-versions["booking-service"]
  svc-port        =  local.booking-config["port"]
  svc-type        =  "ClusterIP"
  container-image =  local.booking-config["container-image"]
  replicas        =  local.booking-config["replicas"]

  ingress-annotations = {
    "kubernetes.io/ingress.class"               = "nginx"
    "nginx.ingress.kubernetes.io/canary"        = "true"
    "nginx.ingress.kubernetes.io/canary-weight" = "20"
  }

  ingress-rules = [{
    http = {
      paths = [{
        backend = {
          serviceName = "v2-custom-booking-service"
          servicePort = local.booking-config["port"]
        }
        path = "/booking"
      }]
    }
  }]

  node-svc-db-enabled    =  "false"

  // RDS info
  rds-endpoint =  module.main-rds.endpoint
  rds-port     =  local.main-rds-config["port"]
  pg-user      =  local.main-rds-config["rds-user"]
  pg-pass      =  local.main-rds-config["rds-pass"]
  root-pg-user =  local.main-rds-config["root-user"]
  root-pg-pass =  local.main-rds-config["root-pass"]

  // Database jobs
  svc-databases       =  ["db-create-custom-booking"]
  rds-user-dependency =  module.rds-user-init-main.uid
  load-data           =  local.booking-config["load-data"]
  data-file-path      =  local.booking-config["data-file-path"]
  global-core-data-reset =  var.global-core-data-reset

  // Health check
  health-check-config = {
    initialDelaySeconds  = 5
    periodSeconds        = 30
    successThreshold     = 1
    timeoutSeconds       = 10

    httpGet = {
      path = "/health"
      port =  local.booking-config["port"]
    }
  }

  // Environment variables
  env-vars = {
    BOOKING_SERVICE_DATABASE_USER           =  local.main-rds-config["rds-user"]
    BOOKING_SERVICE_DATABASE_PASS           =  local.main-rds-config["rds-pass"]
    BOOKING_SERVICE_DATABASE_OPTIONS_HOST   =  module.main-rds.endpoint
    BOOKING_SERVICE_DATABASE_OPTIONS_PORT   =  local.main-rds-config["port"]
    BOOKING_SERVICE_DS_API_HOSTNAME         =  "${local.dispatch-config["name"]}.default.svc.cluster.local."
    BOOKING_SERVICE_DS_API_PORT             =  local.dispatch-config["port"]
    BOOKING_SERVICE_SS_HOSTNAME             =  "${local.scheduling-config["name"]}.default.svc.cluster.local."
    BOOKING_SERVICE_SS_PORT                 =  local.scheduling-config["port"]
    BOOKING_SERVICE_API_SWAGGER_HOST        =  "${local.api-gateway-config["subdomain"]}.${data.external.cluster-info.result["cluster-name"]}"
    BOOKING_SERVICE_API_SWAGGER_BASE_PATH   = "/booking"
    BOOKING_SERVICE_API_SWAGGER_UI_BASE_URL = "https://${local.api-gateway-config["subdomain"]}.${data.external.cluster-info.result["cluster-name"]}/booking"
    BOOKING_SERVICE_API_SWAGGER_SCHEMES     = "[\"https\"]"
    LOGGING_DAILYROTATEFILE_SILENT          = "true"
    CONFIG_SERVICE_HOST                     =  "${local.config-service-config["name"]}.default.svc.cluster.local."
    CONFIG_SERVICE_PORT                     =  local.config-service-config["port"]
    RIDER_MANAGEMENT_SERVICE_HOST           =  "${local.rms-config["name"]}.default.svc.cluster.local."
    RIDER_MANAGEMENT_SERVICE_PORT           =  local.rms-config["port"]
    ADDRESS_SERVICE_ENABLED                 =  contains(local.services-enabled, "address-service") ? local.booking-config["address-service-enabled"] : "false"
    ADDRESS_SERVICE_HOST                    =  "${local.address-config["name"]}.default.svc.cluster.local."
    ADDRESS_SERVICE_PORT                    =  local.address-config["port"]
    TIMEZONE                                =  local.site-config["timezone"]
  }
}
