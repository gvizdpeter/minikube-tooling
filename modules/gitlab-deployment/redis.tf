resource "random_password" "gitlab_redis_password" {
  length  = 20
  special = false
  upper   = true
  lower   = true
  number  = true
}

resource "vault_generic_secret" "gitlab_redis_password" {
  path = "${var.vault_secrets_mountpoint}/${local.gitlab_secrets_vault_path}/redis"

  data_json = jsonencode({
    "password" = "${random_password.gitlab_minio_secret_key.result}"
  })
}

resource "kubernetes_secret" "gitlab_redis_password" {
  metadata {
    name      = "gitlab-redis-password"
    namespace = var.namespace
    labels    = local.gitlab_secret_labels
  }

  data = {
    "${local.gitlab_redis_password_secret_key}" = "${random_password.gitlab_minio_secret_key.result}"
  }

  type = "Opaque"
}

module "redis_pvc" {
  source = "./../pvc"

  namespace = kubernetes_namespace.gitlab.metadata[0].name
  name = "redis-pvc"
  size = "1Gi"
  kubeconfig_path = var.kubeconfig_path
  kubeconfig_context = var.kubeconfig_context
  storage_class_name = var.nfs_storage_class_name
}
