provider "helm" {
  version = "1.3.2"
}

locals {
  envVars           = jsonencode(var.env-vars)
  healthCheckConfig = jsonencode(var.health-check-config)
}

resource "helm_release" "k8s-node-service" {
  name  = var.svc-name
  chart = "${path.module}/artifacts/node-service"

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

  values = [<<EOF
envVars: ${local.envVars}
healthCheckConfig: ${local.healthCheckConfig}
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

