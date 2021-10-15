resource "helm_release" "nfs_provisioner" {
  name             = "nfs-provisioner"
  repository       = "https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner"
  chart            = "nfs-subdir-external-provisioner"
  version          = "4.0.13"
  namespace        = var.namespace
  create_namespace = true
  recreate_pods    = true

  values = [
    templatefile("${path.module}/values/nfs-provisioner.yaml", {
      nfs_server_host        = var.nfs_server_host
      nfs_server_path        = var.nfs_server_path
      nfs_storage_class_name = var.nfs_storage_class_name
    })
  ]
}