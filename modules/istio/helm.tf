resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "istio_base" {
  name          = "istio-base"
  namespace     = kubernetes_namespace.istio_system.metadata[0].name
  chart         = "${path.module}/charts/istio-base"
  recreate_pods = true
}

resource "helm_release" "istio_discovery" {
  name          = "istio-discovery"
  namespace     = kubernetes_namespace.istio_system.metadata[0].name
  chart         = "${path.module}/charts/istio-discovery"
  recreate_pods = true
  depends_on = [
    helm_release.istio_base
  ]
}

resource "helm_release" "istio_ingress" {
  name          = "istio-ingress"
  namespace     = kubernetes_namespace.istio_system.metadata[0].name
  chart         = "${path.module}/charts/istio-ingress"
  recreate_pods = true
  depends_on = [
    helm_release.istio_discovery
  ]
}
