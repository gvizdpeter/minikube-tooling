output "vault_path" {
  value = vault_generic_secret.postgresql_database.path
}

output "kubernetes_secret" {
  value = {
    name         = kubernetes_secret.postgresql_database.metadata[0].name
    namespace    = kubernetes_secret.postgresql_database.metadata[0].namespace
    username_key = local.postgresql_username_key
    password_key = local.postgresql_password_key
    database_key = local.postgresql_database_key
  }
}
