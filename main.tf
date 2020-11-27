provider "helm" {
  version = "1.3.2"
}

resource "helm_release" "k8s-node-service" {
  name       = "node-service"
  chart = "./node-service"

  set_string {
    name  = "enabled"
    value = var.enabled
  }

  set_string {
    name  = "replicaCount"
    value = var.replicas
  }

  set {
    name  = "module.rdsDbMigrate"
    value = var.rds-db-migrate-uids
  }

  set_string {
    name  = "image.repository"
    value = var.container-image
  }

  set_string {
    name  = "image.tag"
    value = var.svc-version
  }

  set_string {
    name  = "service.name"
    value = var.svc-name
  }

  set_string {
    name  = "service.port"
    value = var.svc-port
  }

  set {
    name  = "healthCheckConfig"
    value = var.health-check-config
  }

  set {
    name  = "envVars"
    value = var.env-vars
  }

  values = [
    "${file("values.yaml")}"
  ]    
}

resource "null_resource" "reset-pods" {
  count      = var.enabled == "true" ? 1 : 0
  depends_on = [helm_release.k8s-node-service]

  triggers = {
    env-var-names  = join(",", keys(var.env-vars))
    env-var-values = join(",", values(var.env-vars))
  }

  provisioner "local-exec" {
    command = "for p in $(kubectl get po | awk '/^${var.svc-name}/ {print $1}'); do kubectl delete po $p; done"
  }
}

resource "helm_release" "k8s-node-service-hpa" {
  name       = "node-service-hpa"
  chart = "./node-service-hpa"

  depends_on = [null_resource.reset-pods]
  
  set_string {
    name  = "hpaEnabled"
    value = var.hpa-enabled
  }

  set_string {
    name  = "service.name"
    value = var.svc-name
  }

  set_string {
    name  = "metric"
    value = var.metric
  }

  set_string {
    name  = "metricUtilization"
    value = var.metric-utilization
  }

  set_string {
    name  = "maxReplicas"
    value = var.max-replicas
  }

  set_string {
    name  = "minReplicas"
    value = var.min-replicas
  }
}