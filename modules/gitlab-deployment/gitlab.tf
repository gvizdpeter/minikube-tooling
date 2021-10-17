resource "kubernetes_namespace" "gitlab" {
  metadata {
    name = var.namespace
  }
}

resource "random_password" "gitlab_root_password" {
  length  = 16
  special = false
  upper   = true
  lower   = true
  number  = true
  keepers = {
    "username" = local.gitlab_root_username
  }
}

resource "vault_generic_secret" "gitlab_root_account" {
  path = "${var.vault_secrets_mountpoint}/${local.gitlab_secrets_vault_path}/root"

  data_json = jsonencode({
    "username" = "${random_password.gitlab_root_password.keepers["username"]}"
    "password" = "${random_password.gitlab_root_password.result}"
  })
}

resource "kubernetes_secret" "gitlab_root_password" {
  metadata {
    name      = "gitlab-root-password"
    namespace = kubernetes_namespace.gitlab.metadata[0].name
  }

  data = {
    "${local.gitlab_root_password_secret_key}" = "${random_password.gitlab_root_password.result}"
  }

  type = "Opaque"
}

data "kubernetes_secret" "postgresql_gitlab_database_secret" {
  metadata {
    name      = var.postgresql_gitlab_database_secret.name
    namespace = var.postgresql_gitlab_database_secret.namespace
  }
}

resource "kubernetes_secret" "postgresql_gitlab_database_password_secret" {
  metadata {
    name      = "postgresql-gitlab-database-password-secret"
    namespace = var.namespace
  }

  data = {
    "${local.postgresql_gitlab_database_password_secret_key}" = data.kubernetes_secret.postgresql_gitlab_database_secret.data[var.postgresql_gitlab_database_secret.password_key]
  }

  type = "Opaque"
}

resource "random_password" "gitlab_runner_registration_token" {
  length  = 20
  special = false
  upper   = true
  lower   = true
  number  = true
}

resource "vault_generic_secret" "gitlab_runner_registration_token" {
  path = "${var.vault_secrets_mountpoint}/${local.gitlab_secrets_vault_path}/runner-registration-token"

  data_json = jsonencode({
    "token" = "${random_password.gitlab_runner_registration_token.result}"
  })
}

resource "kubernetes_secret" "gitlab_runner_registration_token" {
  metadata {
    name      = "gitlab-runner-registration-token"
    namespace = var.namespace
  }

  data = {
    "${local.gitlab_runner_registration_token_secret_key}" = "${random_password.gitlab_runner_registration_token.result}"
  }

  type = "Opaque"
}

resource "helm_release" "gitlab" {
  name          = "gitlab"
  repository    = "https://charts.gitlab.io"
  chart         = "gitlab"
  version       = "5.3.3"
  namespace     = kubernetes_namespace.gitlab.metadata[0].name
  recreate_pods = true

  values = [
    templatefile("${path.module}/values/gitlab.yaml", {
      gitlab_hostname                                = var.gitlab_hostname
      nfs_storage_class_name                         = var.nfs_storage_class_name
      http_secured                                   = var.http_secured ? "true" : "false"
      ingress_class                                  = var.ingress_class
      gitlab_root_password_secret                    = kubernetes_secret.gitlab_root_password.metadata[0].name
      gitlab_root_password_secret_key                = local.gitlab_root_password_secret_key
      postgresql_address                             = local.postgresql_address
      postgresql_port                                = local.postgresql_port
      postgresql_gitlab_database_username            = data.kubernetes_secret.postgresql_gitlab_database_secret.data[var.postgresql_gitlab_database_secret.username_key]
      postgresql_gitlab_database_name                = data.kubernetes_secret.postgresql_gitlab_database_secret.data[var.postgresql_gitlab_database_secret.database_key]
      postgresql_gitlab_database_password_secret     = kubernetes_secret.postgresql_gitlab_database_password_secret.metadata[0].name
      postgresql_gitlab_database_password_secret_key = local.postgresql_gitlab_database_password_secret_key
      gitlab_runner_registration_token_secret        = kubernetes_secret.gitlab_runner_registration_token.metadata[0].name
      gitlab_minio_secret                            = kubernetes_secret.gitlab_minio_secret.metadata[0].name
    })
  ]
}
