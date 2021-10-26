output "istio_ingress_gateway_name" {
  value     = "${var.namespace}/${local.istio_ingress_gateway_name}"
  depends_on = [
    kubectl_manifest.istio_ingress_gateway
  ]
}

output "istio_tls_ca_crt" {
  value = tls_self_signed_cert.ca_crt.cert_pem
  sensitive = true
  depends_on = [
    kubectl_manifest.istio_ingress_gateway
  ]
}
