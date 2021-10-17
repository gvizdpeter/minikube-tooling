resource "random_password" "artifactory_master_key" {
  length  = 16
  special = false
  upper   = true
  lower   = true
  number  = true
}

resource "random_password" "artifactory_join_key" {
  length  = 16
  special = false
  upper   = true
  lower   = true
  number  = true
}

resource "random_password" "artifactory_admin_password" {
  length  = 16
  special = false
  upper   = true
  lower   = true
  number  = true
  keepers = {
    "username" = local.artifactory_admin_username
  }
}

resource "vault_generic_secret" "artifactory_admin" {
  path = "${var.vault_secrets_mountpoint}/${local.vault_artifactory_secrets_path}/admin"

  data_json = jsonencode({
    "username"   = "${random_password.artifactory_admin_password.keepers["username"]}"
    "password"   = "${random_password.artifactory_admin_password.result}"
    "master_key" = "${local.master_key}"
    "join_key"   = "${local.join_key}"
  })
}

resource "kubernetes_namespace" "artifactory" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret" "artifactory_admin" {
  metadata {
    name      = "artifactory-admin"
    namespace = kubernetes_namespace.artifactory.metadata[0].name
  }

  data = {
    "${local.admin_creds_secret_key}" = "${random_password.artifactory_admin_password.keepers["username"]}@*=${random_password.artifactory_admin_password.result}"
    "${local.master_key_secret_key}"  = "${local.master_key}"
    "${local.join_key_secret_key}"    = "${local.join_key}"
  }

  type = "Opaque"
}

data "kubernetes_secret" "postgresql_artifactory_database_secret" {
  metadata {
    name      = var.postgresql_artifactory_database_secret.name
    namespace = var.postgresql_artifactory_database_secret.namespace
  }
}

resource "kubernetes_secret" "postgresql_artifactory_database_secret" {
  metadata {
    name      = "postgresql-artifactory-database"
    namespace = kubernetes_namespace.artifactory.metadata[0].name
  }

  data = {
    "${local.postgresql_artifactory_database_url_key}"      = "jdbc:postgresql://${var.postgresql_address}/${data.kubernetes_secret.postgresql_artifactory_database_secret.data[var.postgresql_artifactory_database_secret.database_key]}"
    "${local.postgresql_artifactory_database_username_key}" = "${data.kubernetes_secret.postgresql_artifactory_database_secret.data[var.postgresql_artifactory_database_secret.username_key]}"
    "${local.postgresql_artifactory_database_password_key}" = "${data.kubernetes_secret.postgresql_artifactory_database_secret.data[var.postgresql_artifactory_database_secret.password_key]}"
  }

  type = "Opaque"
}

data "vault_generic_secret" "artifactory_license" {
  path = "${var.vault_secrets_mountpoint}/${var.vault_artifactory_license_path}"
}

resource "kubernetes_secret" "artifactory_license" {
  metadata {
    name      = "artifactory-license"
    namespace = kubernetes_namespace.artifactory.metadata[0].name
  }

  data = {
    "${local.artifactory_license_secret_key}" = "${data.vault_generic_secret.artifactory_license.data["license"]}"
  }

  type = "Opaque"
}

resource "helm_release" "artifactory" {
  name          = "artifactory"
  repository    = "https://charts.jfrog.io"
  chart         = "artifactory-jcr"
  version       = "107.27.3"
  namespace     = kubernetes_namespace.artifactory.metadata[0].name
  recreate_pods = true

  values = [
    templatefile("${path.module}/values/artifactory.yaml", {
      nfs_storage_class_name                       = var.nfs_storage_class_name
      artifactory_hostname                         = var.artifactory_hostname
      http_protocol                                = var.http_secured ? "https" : "http"
      ingress_class                                = var.ingress_class
      artifactory_admin_secret                     = kubernetes_secret.artifactory_admin.metadata[0].name
      artifactory_admin_creds_secret_key           = local.admin_creds_secret_key
      postgresql_artifactory_database_secret       = kubernetes_secret.postgresql_artifactory_database_secret.metadata[0].name
      postgresql_artifactory_database_url_key      = local.postgresql_artifactory_database_url_key
      postgresql_artifactory_database_username_key = local.postgresql_artifactory_database_username_key
      postgresql_artifactory_database_password_key = local.postgresql_artifactory_database_password_key
      artifactory_docker_virtual_repository_name   = local.artifactory_docker_virtual_repository_name
      artifactory_license_secret                   = kubernetes_secret.artifactory_license.metadata[0].name
      artifactory_license_secret_key               = local.artifactory_license_secret_key
    })
  ]
}
