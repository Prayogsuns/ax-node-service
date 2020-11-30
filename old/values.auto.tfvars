enabled = "true"

svc-name = "my-service"

svc-port = "8080"

replicas = "3"

container-image = "nginx"

svc-version = "latest"

hpa-enabled = "true"

metric = "cpu"

metric-utilization = "50"

max-replicas = "10"

min-replicas = "1"
