resource "kubernetes_namespace" "prometheus" {
  metadata {
    name = var.namespace
    labels = {
      istio-injection = "enabled"
    }
  }
}

resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  version          = "14.11.0"
  namespace        = kubernetes_namespace.prometheus.metadata[0].name
  recreate_pods    = true

  values = [
    templatefile("${path.module}/values/prometheus.yaml", {
      pvc_name = module.prometheus_pvc.name
      storage_retention = "1GB"
    })
  ]
}

module "prometheus_virtual_service" {
  source = "./../istio-virtual-service"

  name = "prometheus"
  namespace = kubernetes_namespace.prometheus.metadata[0].name
  domain = var.prometheus_domain
  subdomain = var.prometheus_subdomain
  routes = [{
    service_name = "prometheus-server"
    service_port = 80
    prefix = "/"
  }]
  istio_ingress_gateway_name = var.istio_ingress_gateway_name
  kubeconfig_path = var.kubeconfig_path
  kubeconfig_context = var.kubeconfig_context
}

module "prometheus_pvc" {
  source = "./../pvc"

  namespace = kubernetes_namespace.prometheus.metadata[0].name
  name = "prometheus-pvc"
  size = "1Gi"
  kubeconfig_path = var.kubeconfig_path
  kubeconfig_context = var.kubeconfig_context
  storage_class_name = var.nfs_storage_class_name
}
