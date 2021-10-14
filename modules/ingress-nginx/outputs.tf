output "ingress_class" {
  value = var.ingess_class_name

  depends_on = [
    helm_release.ingress_nginx
  ]
}
