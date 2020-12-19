provider "helm" {
  alias  = "helm"
  version = "1.3.2"
}

module "my-service" {
  source = "./module"

  providers = {
    helm = helm.helm
  }

  count = var.nodeSvcDbEnabled ? 1 : 0
  
  namespace = "default"

  enabled = "true"

  hpa-enabled        = "true"
  metric             = "cpu"
  metric-utilization = 40
  max-replicas       = 8
  min-replicas       = 1


  // Kubernetes config
  svc-name        =  "my-service"
  svc-version     =  "latest"
  svc-port        =  "5000"
  svc-type        =  "ClusterIP"
  container-image =  "poroko/flask-demo-app" 
  replicas        =  3
  rds-db-migrate-uids = "cc32b243-a94a-11ea-afd7-124a2054baaa"

  // Environment variables
  env-vars = {
    BOOKING_SERVICE_API_SWAGGER_BASE_PATH   = "/booking"
    BOOKING_SERVICE_API_SWAGGER_SCHEMES     = "[\"https\"]"
    LOGGING_DAILYROTATEFILE_SILENT          = "true"
  }

  // Health check
  health-check-config = {
    initialDelaySeconds  = 1
    periodSeconds        = 5
    successThreshold     = 1
    timeoutSeconds       = 5
  
    httpGet = {
      path = "/"
      port = 5000
    }
  }

  ingress-annotations = {
    "kubernetes.io/ingress.class"               = "nginx"
  }

  ingress-rules = [{
    host = "flask-demo.example.com"
    http = {
      paths = [{
        backend = {
          serviceName = "my-service"
          servicePort = 5000
        }
        path = "/"
      }]
    }
  }]

}

output "my-service-mod" {
  value = module.my-service
}
