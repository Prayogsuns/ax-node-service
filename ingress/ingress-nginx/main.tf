module "ingress-nginx-controller-service" {
  source = "./module/ingress"

  ingress-release-name = "my-ingress-ctrl"

  repository-url       = "https://kubernetes.github.io/ingress-nginx" 
  chart-name           = "ingress-nginx" 
  chart-version        = "2.16.0" 
  
  namespace            = "ingress-nginx"
  max-history          = 3
}


