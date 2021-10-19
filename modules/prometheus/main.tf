resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  version          = "14.11.0"
  namespace        = var.namespace
  create_namespace = true
  recreate_pods    = true

  values = [
    templatefile("${path.module}/values/prometheus.yaml", {
      nfs_storage_class_name = var.nfs_storage_class_name
      prometheus_hostname    = var.prometheus_hostname
      ingress_class          = var.ingress_class
      storage_size_in_gb     = 1
    })
  ]
}
