locals {
  ca_cert_path = "tls/ca.crt"
  organization = regex("^[a-zA-Z0-9]+", var.domain)
  istio_ingress_gateway_name = "istio-ingress-gateway"
}
