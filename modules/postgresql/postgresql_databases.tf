module "artifactory_database" {
  source = "./modules/postgresql-database"

  username      = "artifactory"
  database_name = "artifactory"
  vault_path    = "${var.vault_secrets_mountpoint}/${local.postgresql_vault_secrets_path}"
  namespace     = kubernetes_namespace.postgresql.metadata[0].name
}

module "gitlab_database" {
  source = "./modules/postgresql-database"

  username      = "gitlab"
  database_name = "gitlab"
  vault_path    = "${var.vault_secrets_mountpoint}/${local.postgresql_vault_secrets_path}"
  namespace     = kubernetes_namespace.postgresql.metadata[0].name
}
