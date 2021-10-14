resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.0.3"
  namespace        = var.namespace
  create_namespace = true
  recreate_pods = true

  values = [
    templatefile("${path.module}/values/ingress-nginx.yaml", {
      ingess_class_name = var.ingess_class_name
    })
  ]
}