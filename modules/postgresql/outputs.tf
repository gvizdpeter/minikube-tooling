output "postgresql_service_address" {
  value = "${helm_release.postgresql.name}.${helm_release.postgresql.namespace}:${local.postgresql_port}"
  depends_on = [
    helm_release.postgresql
  ]
}

output "artifactory_database_secret" {
  value = {
    name      = kubernetes_secret.postgresql_artifactory.metadata[0].name
    namespace = helm_release.postgresql.namespace
  }
  depends_on = [
    helm_release.postgresql
  ]
}
