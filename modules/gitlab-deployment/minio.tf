resource "random_password" "gitlab_minio_access_key" {
  length  = 20
  special = false
  upper   = true
  lower   = true
  number  = true
}

resource "random_password" "gitlab_minio_secret_key" {
  length  = 40
  special = false
  upper   = true
  lower   = true
  number  = true
  keepers = {
    "access-key" = random_password.gitlab_minio_access_key.result
  }
}

resource "vault_generic_secret" "gitlab_minio_secret" {
  path = "${var.vault_secrets_mountpoint}/${local.gitlab_secrets_vault_path}/minio"

  data_json = jsonencode({
    "access-key" = "${random_password.gitlab_minio_secret_key.keepers["access-key"]}"
    "secret-key" = "${random_password.gitlab_minio_secret_key.result}"
  })
}

resource "kubernetes_secret" "gitlab_minio_secret" {
  metadata {
    name      = "gitlab-minio-secret"
    namespace = var.namespace
    labels    = local.gitlab_secret_labels
  }

  data = {
    "${local.gitlab_minio_access_key}" = "${random_password.gitlab_minio_secret_key.keepers["access-key"]}"
    "${local.gitlab_minio_secret_key}" = "${random_password.gitlab_minio_secret_key.result}"
  }

  type = "Opaque"
}

module "minio_pvc" {
  source = "./../pvc"

  namespace = kubernetes_namespace.gitlab.metadata[0].name
  name = "minio-pvc"
  size = "1Gi"
  kubeconfig_path = var.kubeconfig_path
  kubeconfig_context = var.kubeconfig_context
  storage_class_name = var.nfs_storage_class_name
}
