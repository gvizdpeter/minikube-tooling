resource "kubernetes_namespace" "keda" {
  metadata {
    name = var.namespace
    labels = {
      istio-injection = "enabled"
    }
  }
}

resource "helm_release" "keda" {
  name          = "keda"
  repository    = "https://kedacore.github.io/charts"
  chart         = "keda"
  version       = "2.4.0"
  namespace     = kubernetes_namespace.keda.metadata[0].name
  recreate_pods = true
}
