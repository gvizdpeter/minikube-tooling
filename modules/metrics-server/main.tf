resource "helm_release" "metrics_server" {
  name          = "metrics-server"
  repository    = "https://charts.bitnami.com/bitnami"
  chart         = "metrics-server"
  version       = "5.10.4"
  namespace     = var.namespace
  recreate_pods = true
  force_update  = true

  values = [
    file("${path.module}/values/metrics-server.yaml")
  ]
}
