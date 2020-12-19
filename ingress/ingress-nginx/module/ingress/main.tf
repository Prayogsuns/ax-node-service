
resource "helm_release" "ingress-nginx-controller" {
  name       = var.ingress-release-name

  // repository = "https://kubernetes.github.io/ingress-nginx"
  // chart      = "ingress-nginx"
  // version    = "2.16.0"

  repository = var.repository-url
  chart      = var.chart-name
  version    = var.chart-version

  namespace   = var.namespace
  max_history = var.max-history

  values = [
    file("${path.module}/values.yaml")
  ]
}
