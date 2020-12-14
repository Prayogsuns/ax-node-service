locals {
  envVars           = jsonencode(var.env-vars)
  healthCheckConfig = jsonencode(var.health-check-config)
}

resource "helm_release" "k8s-node-service" {
  count      = var.enabled == "true" ? 1 : 0

  name  = var.svc-name
  chart = "${path.module}/artifacts/node-service"
  namespace = var.namespace

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
    name  = "rdsDbMigrateUids"
    value = var.node-svc-db-enabled ? join(" ", list(module.rds-db-migrate[0].uid)) : jsonencode("")
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

module "rds-db-create" {
  source = "../rds/modules/rds-db"
  count = var.node-svc-db-enabled ? 1 : 0

  enabled = var.enabled

  databases      = var.svc-databases
  port           = var.rds-port
  rds-endpoint   = var.rds-endpoint
  db-owner       = var.pg-user
  pg-user        = var.root-pg-user
  pg-pass        = var.root-pg-pass
  force-recreate = var.db-force-recreate

  manual_depends_on = [var.rds-user-dependency]
}

module "rds-db-migrate" {
  source = "../rds/modules/rds-migration"
  count = var.node-svc-db-enabled ? 1 : 0

  enabled = var.enabled

  image        = var.container-image
  svc-version  = var.svc-version
  port         = var.rds-port
  databases    = var.svc-databases
  rds-endpoint = var.rds-endpoint
  pg-user      = var.pg-user
  pg-pass      = var.pg-pass

  manual_depends_on = ["${length(var.svc-databases) > 0 ? module.rds-db-create[0].uid : ""}"]
}

module "rds-db-dump-npm" {
  source = "../rds/modules/rds-db-dump-npm"
  count = var.node-svc-db-enabled ? 1 : 0

  databases      = var.svc-databases
  dump-file-path = var.data-file-path
  image          = var.container-image
  svc-version    = var.svc-version
  port           = var.rds-port
  rds-endpoint   = var.rds-endpoint
  pg-user        = var.pg-user
  pg-pass        = var.pg-pass
  enable-db-dump = "${var.enabled == "true" ? var.load-data : "false"}"
  filename       = var.data-file-path
  npm-command    = var.db-dump-npm-command
  enable-global-core-data-reset   = "${var.enabled == "true" ? var.global-core-data-reset : "false"}"

  manual_depends_on = ["${length(var.svc-databases) > 0 ? module.rds-db-migrate[0].uid : ""}"] 
}
