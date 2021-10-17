resource "kubernetes_namespace" "postgresql" {
  metadata {
    name = var.namespace
  }
}

resource "random_password" "postgresql_admin_password" {
  length  = 16
  special = false
  upper   = true
  lower   = true
  number  = true
  keepers = {
    "username" = local.postgresql_admin_username
  }
}

resource "vault_generic_secret" "postgresql_admin" {
  path = "${var.vault_secrets_mountpoint}/${local.postgresql_vault_secrets_path}/admin"

  data_json = jsonencode({
    "username" = "${random_password.postgresql_admin_password.keepers["username"]}"
    "password" = "${random_password.postgresql_admin_password.result}"
    "database" = local.postgresql_database
  })
}

resource "kubernetes_secret" "postgresql_admin_password" {
  metadata {
    name      = "postgresql-admin-password"
    namespace = kubernetes_namespace.postgresql.metadata[0].name
  }

  data = {
    "${local.postgresql_password_key}" = "${random_password.postgresql_admin_password.result}"
  }

  type = "Opaque"
}

resource "helm_release" "postgresql" {
  name          = "postgresql"
  repository    = "https://charts.bitnami.com/bitnami"
  chart         = "postgresql"
  version       = "10.12.0"
  namespace     = kubernetes_namespace.postgresql.metadata[0].name
  recreate_pods = true

  values = [
    templatefile("${path.module}/values/postgresql.yaml", {
      postgresql_admin_password_secret    = kubernetes_secret.postgresql_admin_password.metadata[0].name
      postgresql_database                 = local.postgresql_database
      postgresql_admin_username           = local.postgresql_admin_username
      postgresql_port                     = local.postgresql_port
      postgresql_artifactory_secret       = module.artifactory_database.kubernetes_secret.name
      postgresql_artifactory_username_key = module.artifactory_database.kubernetes_secret.username_key
      postgresql_artifactory_password_key = module.artifactory_database.kubernetes_secret.password_key
      postgresql_artifactory_database_key = module.artifactory_database.kubernetes_secret.database_key
      postgresql_gitlab_secret            = module.gitlab_database.kubernetes_secret.name
      postgresql_gitlab_username_key      = module.gitlab_database.kubernetes_secret.username_key
      postgresql_gitlab_password_key      = module.gitlab_database.kubernetes_secret.password_key
      postgresql_gitlab_database_key      = module.gitlab_database.kubernetes_secret.database_key
      storage_class_name                  = var.nfs_storage_class_name
    })
  ]
}
