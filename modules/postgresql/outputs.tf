output "postgresql_service_address" {
  value = "${helm_release.postgresql.name}.${helm_release.postgresql.namespace}:${local.postgresql_port}"
  depends_on = [
    helm_release.postgresql
  ]
}

output "postgresql_artifactory_database_vault_secret" {
  value = module.artifactory_database.vault_path
  depends_on = [
    helm_release.postgresql
  ]
}

output "postgresql_gitlab_database_vault_secret" {
  value = module.gitlab_database.vault_path
  depends_on = [
    helm_release.postgresql
  ]
}
