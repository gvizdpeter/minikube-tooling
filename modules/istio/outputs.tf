output "istio_ingress_gateway_name" {
  value     = "${var.namespace}/${local.istio_ingress_gateway_name}"
  sensitive = true
  depends_on = [
    kubectl_manifest.istio_ingress_gateway
  ]
}
