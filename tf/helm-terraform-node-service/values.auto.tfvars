enabled = "true"

svc-name = "my-service"

svc-port = "5000"

replicas = "3"

container-image = "poroko/flask-demo-app"

svc-version = "latest"

hpa-enabled = "true"

metric = "cpu"

metric-utilization = "50"

max-replicas = "10"

min-replicas = "1"
