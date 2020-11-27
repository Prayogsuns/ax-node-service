enabled = "true"

svc-name = "my-service"

svc-port = "8080"

replicas = "3"

rds-db-migrate-uids = [
  "e717c955-98d6-11ea-afd7-124a2054baaa",
]

container-image = "nginx"

svc-version = "latest"

health-check-config = {
  initial_delay_seconds = 5
  period_seconds        = 30
  success_threshold     = 1
  timeout_seconds       = 10

  http_get = [{
    path = "/health"
    port = "8080"
  }]
}


env-vars = {
  SWAGGER_SCHEMES                                 = "[\"https\"]"
  ELASTICSEARCH_SERVICE_AWS_ARCHIVE_TYPE          = "s3"
  ELASTICSEARCH_SERVICE_PROTOCOL                  = "https"
  ELASTICSEARCH_SERVICE_PORT                      = "443"
  ELASTICSEARCH_SERVICE_PATH_PREFIX               = "/"
}

hpa-enabled = "true"

metric = "cpu"

metric-utilization = "50"

max-replicas = "10"

min-replicas = "1"
