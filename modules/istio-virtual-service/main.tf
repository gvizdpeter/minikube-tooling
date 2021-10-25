resource "kubectl_manifest" "istio_virtual_service" {
  yaml_body = templatefile("${path.module}/manifests/virtual-service.yaml", {
    namespace = var.namespace
    domain = var.domain
    subdomain = var.subdomain
    service_name = var.service_name
    service_port = var.service_port
    istio_ingress_gateway_name = var.istio_ingress_gateway_name
  })
}
