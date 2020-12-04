enabled = "true"

svc-name = "my-service"

svc-port = "5000"

replicas = "3"

container-image = "poroko/flask-demo-app"

svc-version = "latest"

rds-db-migrate-uids = "cc32b243-a94a-11ea-afd7-124a2054baaa"

hpa-enabled = "true"

metric = "cpu"

metric-utilization = "50"

max-replicas = "10"

min-replicas = "1"
