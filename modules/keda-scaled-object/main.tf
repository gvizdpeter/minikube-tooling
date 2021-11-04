resource "kubectl_manifest" "keda_scaled_object" {
  yaml_body = templatefile("${path.module}/manifests/scaled-object.yaml", {
    namespace          = var.namespace
    name               = var.name
    scaled_deployment  = var.scaled_deployment
    polling_interval   = var.polling_interval
    cooldown_period    = var.cooldown_period
    min_replica_count  = var.min_replica_count
    max_replica_count  = var.max_replica_count
    prometheus_address = var.prometheus_address
    metric_name        = var.metric_name
    threshold          = var.threshold
    query              = var.query
  })
}
