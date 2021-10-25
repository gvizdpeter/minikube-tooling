resource "kubernetes_persistent_volume_claim" "pvc" {
  metadata {
    name = var.name
    namespace = var.namespace
  }
  spec {
    access_modes = var.access_modes
    resources {
      requests = {
        storage = var.size
      }
    }
    storage_class_name = var.storage_class_name
  }
}