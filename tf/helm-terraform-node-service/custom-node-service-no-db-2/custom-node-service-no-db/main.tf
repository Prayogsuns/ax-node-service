locals {
  envVars           = jsonencode(var.env-vars)
  healthCheckConfig = jsonencode(var.health-check-config)
  ingressAnnotations = jsonencode(var.ingress-annotations)
  ingressRules = jsonencode(var.ingress-rules)
}

resource "helm_release" "k8s-node-service" {
  count      = var.enabled == "true" ? 1 : 0

  name  = var.svc-name
  chart = "${path.module}/artifacts/node-service"
  namespace = var.namespace
  max_history = var.max-history

  set {
    name  = "enabled"
    value = var.enabled
  }

  set {
    name  = "replicaCount"
    value = var.replicas
	type = "string"
  }

  set {
    name  = "image.repository"
    value = var.container-image
	type = "string"
  }

  set {
    name  = "image.tag"
    value = var.svc-version
	type = "string"
  }

  set {
    name  = "service.name"
    value = var.svc-name
	type = "string"
  }

  set {
    name  = "service.port"
    value = var.svc-port
	type = "string"
  }

  set {
    name  = "service.type"
    value = var.svc-type
    type = "string"
  }

  set {
    name  = "hpaEnabled"
    value = var.hpa-enabled
  }

  set {
    name  = "metric"
    value = var.metric
        type = "string"
  }

  set {
    name  = "metricUtilization"
    value = var.metric-utilization
        type = "string"
  }

  set {
    name  = "maxReplicas"
    value = var.max-replicas
        type = "string"
  }

  set {
    name  = "minReplicas"
    value = var.min-replicas
        type = "string"
  }

  values = [<<EOF
envVars: ${local.envVars}
healthCheckConfig: ${local.healthCheckConfig}
ingress:
  annotations: ${local.ingressAnnotations}
  rules: ${local.ingressRules}
EOF
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

