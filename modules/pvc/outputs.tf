output "name" {
  value = var.name
  depends_on = [
    kubernetes_persistent_volume_claim.pvc
  ]
}

output "size" {
  value = var.size
  depends_on = [
    kubernetes_persistent_volume_claim.pvc
  ]
}
