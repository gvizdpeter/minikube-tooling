output "prometheus_address" {
  value = "http://${local.prometheus_service_name}.${var.namespace}:${local.prometheus_service_port}"

  depends_on = [
    helm_release.prometheus
  ]
}
