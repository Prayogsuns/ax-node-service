module "custom-iq-dispatch-adapter-service" {
  source = "./modules/custom-node-service-no-db"

  enabled =  contains(local.services-enabled, "iq-dispatch-adapter-service") ? "true" : "false"

  // Kubernetes config
  namespace       =  "default"
  svc-name        =  "custom-iq-dispatch-adapter-service"
  svc-version     =  local.project-versions["iq-dispatch-adapter-service"]
  svc-port        =  local.iq-dispatch-adapter-service-config["port"]
  svc-type        =  "ClusterIP"
  container-image =  local.iq-dispatch-adapter-service-config["container-image"]
  replicas        =  local.iq-dispatch-adapter-service-config["replicas"]

  // Health check
  health-check-config = {
    initialDelaySeconds = 5
    periodSeconds        = 30
    successThreshold     = 1
    timeoutSeconds       = 10

    tcpSocket = {
      port =  local.iq-dispatch-adapter-service-config["port"]
    }
  }

  // Environment variables
  env-vars = {
    ADDRESS_SERVICE_HOST                                =  "${local.address-config["name"]}.default.svc.cluster.local."
    ADDRESS_SERVICE_PORT                                =  local.address-config["port"]
    BOOKING_SERVICE_HOST                                =  "${local.booking-config["name"]}.default.svc.cluster.local."
    BOOKING_SERVICE_PORT                                =  local.booking-config["port"]
    TRANSIT_DISPATCH_SERVICE_HOST                       =  "${local.dispatch-config["name"]}.default.svc.cluster.local."
    TRANSIT_DISPATCH_SERVICE_PORT                       =  local.dispatch-config["port"]
    CONFIG_SERVICE_HOST                                 =  "${local.config-service-config["name"]}.default.svc.cluster.local."
    CONFIG_SERVICE_PORT                                 =  local.config-service-config["port"]
    RIDER_MANAGEMENT_SERVICE_HOST                       =  "${local.rms-config["name"]}.default.svc.cluster.local."
    RIDER_MANAGEMENT_SERVICE_PORT                       =  local.rms-config["port"]
    TRANSIT_VEHICLE_SERVICE_HOST                        =  "${local.vehicle-service-config["name"]}.default.svc.cluster.local."
    TRANSIT_VEHICLE_SERVICE_PORT                        =  local.vehicle-service-config["port"]
    TRANSIT_DRIVER_SERVICE_HOST                         =  "${local.driver-service-config["name"]}.default.svc.cluster.local."
    TRANSIT_DRIVER_SERVICE_PORT                         =  local.driver-service-config["port"]
    SCHEDULE_ROUTE_SERVICE_HOST                         =  "${local.scheduling-config["name"]}.default.svc.cluster.local."
    SCHEDULE_ROUTE_SERVICE_PORT                         =  local.scheduling-config["port"]
    AVLM_SERVICE_PROTOCOL                               = "https"
    AVLM_SERVICE_HOST                                   =  "${local.api-gateway-config["subdomain"]}.${data.external.cluster-info.result["cluster-name"]}"
    AVLM_SERVICE_PORT                                   = "443"
    AVLM_SERVICE_TOP_LEVEL_PATH                         = "/avlm/"
    AVLM_SERVICE_ENABLED                                = "true"
    IQ_DISPATCH_ADAPTER_SERVICE_API_SWAGGER_HOST        =  "${local.api-gateway-config["subdomain"]}.${data.external.cluster-info.result["cluster-name"]}"
    IQ_DISPATCH_ADAPTER_SERVICE_API_SWAGGER_BASE_PATH   = "/iq-dispatch-adapter"
    IQ_DISPATCH_ADAPTER_SERVICE_API_SWAGGER_UI_BASE_URL = "https://${local.api-gateway-config["subdomain"]}.${data.external.cluster-info.result["cluster-name"]}/iq-dispatch-adapter"
    IQ_DISPATCH_ADAPTER_SERVICE_API_SWAGGER_SCHEMES     = "[\"https\"]"
    AVLM_SERVICE_URL                                    = "https://${local.api-gateway-config["subdomain"]}.${data.external.cluster-info.result["cluster-name"]}/avlm"
    TIMEZONE                                            =  local.site-config["timezone"]
  }
}
