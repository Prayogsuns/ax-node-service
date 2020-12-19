provider "helm" {
  alias  = "helm"
  version = "1.3.2"
}

module "hy-service" {
  source = "./module"

  providers = {
    helm = helm.helm
  }

  count = var.nodeSvcDbEnabled ? 1 : 0
  
  namespace = "default"

  enabled = "false"

  hpa-enabled        = "false"
  metric             = "cpu"
  metric-utilization = 40
  max-replicas       = 8
  min-replicas       = 1


  // Kubernetes config
  svc-name        =  "hy-service"
  svc-version     =  "1.0.0"
  svc-port        =  "8080"
  svc-type        =  "ClusterIP"
  container-image =  "stoehdoi/canary-demo" 
  replicas        =  3
  rds-db-migrate-uids = "cc32b243-a94a-11ea-afd7-124a2054baaa"

  // Environment variables
  env-vars = {
    VERSION                                 = "1.0.0"
  }

  // Health check
  health-check-config = {
    initialDelaySeconds  = 1
    periodSeconds        = 5
    successThreshold     = 1
    timeoutSeconds       = 5
  
    httpGet = {
      path = "/version"
      port = 8080
    }
  }

  ingress-annotations = {
    "kubernetes.io/ingress.class"               = "nginx"
  }

  ingress-rules = [{
    host = "app-demo.example.com"
    http = {
      paths = [{
        backend = {
          serviceName = "hy-service"
          servicePort = 8080
        }
        path = "/version"
      }]
    }
  }]

}

module "hy-service-canary" {
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
  svc-name        =  "hy-service-canary"
  svc-version     =  "1.0.0"
  svc-port        =  "8080"
  svc-type        =  "ClusterIP"
  container-image =  "stoehdoi/canary-demo"
  replicas        =  3
  rds-db-migrate-uids = "cc32b243-a94a-11ea-afd7-124a2054baaa"

  // Environment variables
  env-vars = {
    VERSION                                 = "1.0.1 - canary"
  }

  // Health check
  health-check-config = {
    initialDelaySeconds  = 1
    periodSeconds        = 5
    successThreshold     = 1
    timeoutSeconds       = 5

    httpGet = {
      path = "/version"
      port = 8080
    }
  }

  ingress-annotations = {
    "kubernetes.io/ingress.class"               = "nginx"
  }

  ingress-rules = [{
    host = "app-demo.example.com"
    http = {
      paths = [{
        backend = {
          serviceName = "hy-service-canary"
          servicePort = 8080
        }
        path = "/version"
      }]
    }
  }]

}

/*
output "hy-service-mod" {
  value = module.hy-service
}
*/

