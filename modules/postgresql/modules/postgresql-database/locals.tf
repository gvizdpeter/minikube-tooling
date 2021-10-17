locals {
  postgresql_username_key = "${var.database_name}-username"
  postgresql_password_key = "${var.database_name}-password"
  postgresql_database_key = "${var.database_name}-database"
  vault_path              = "${var.vault_path}/${var.database_name}"
}
