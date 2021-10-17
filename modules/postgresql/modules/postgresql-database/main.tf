resource "random_password" "postgresql_database_password" {
  length  = 16
  special = false
  upper   = true
  lower   = true
  number  = true
  keepers = {
    "username" = var.username
  }
}

resource "vault_generic_secret" "postgresql_database" {
  path = local.vault_path

  data_json = jsonencode({
    "username" = "${random_password.postgresql_database_password.keepers["username"]}"
    "password" = "${random_password.postgresql_database_password.result}"
    "database" = var.database_name
  })
}

resource "kubernetes_secret" "postgresql_database" {
  metadata {
    name      = "postgresql-${var.database_name}"
    namespace = var.namespace
  }

  data = {
    "${local.postgresql_username_key}" = "${random_password.postgresql_database_password.keepers["username"]}"
    "${local.postgresql_password_key}" = "${random_password.postgresql_database_password.result}"
    "${local.postgresql_database_key}" = "${var.database_name}"
  }

  type = "Opaque"
}
