resource "kubectl_manifest" "istio_virtual_service" {
  yaml_body = templatefile("${path.module}/manifests/virtual-service.yaml", {
    namespace = var.namespace
    domain = var.domain
    subdomain = var.subdomain
    routes = var.routes
    istio_ingress_gateway_name = var.istio_ingress_gateway_name
    name = var.name
  })
}
