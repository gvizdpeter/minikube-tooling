resource "kubectl_manifest" "istio_ingress_gateway" {
  yaml_body = templatefile("${path.module}/manifests/gateway.yaml", {
    gateway_name    = local.istio_ingress_gateway_name
    namespace       = kubernetes_namespace.istio_system.metadata[0].name
    tls_secret_name = kubernetes_secret.istio_tls.metadata[0].name
    domain          = var.domain
  })

  depends_on = [
    helm_release.istio_ingress
  ]
}