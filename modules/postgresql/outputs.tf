output "postgresql_service_address" {
  value = "${helm_release.postgresql.name}.${helm_release.postgresql.namespace}:${local.postgresql_port}"
  depends_on = [
    helm_release.postgresql
  ]
}

output "artifactory_database_secret" {
  value = module.artifactory_database.kubernetes_secret
  depends_on = [
    helm_release.postgresql
  ]
}

output "gitlab_database_secret" {
  value = module.gitlab_database.kubernetes_secret
  depends_on = [
    helm_release.postgresql
  ]
}
