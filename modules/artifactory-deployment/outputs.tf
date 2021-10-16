output "artifactory_admin_vault_path" {
  value = vault_generic_secret.artifactory_admin.path
  depends_on = [
    helm_release.artifactory
  ]
}

output "artifactory_address" {
  value = "${var.http_secured ? "https" : "http"}://${var.artifactory_hostname}"
  depends_on = [
    helm_release.artifactory
  ]
}

output "vault_artifactory_secrets_path" {
  value = local.vault_artifactory_secrets_path
  depends_on = [
    helm_release.artifactory
  ]
}

output "artifactory_docker_virtual_repository_name" {
  value = local.artifactory_docker_virtual_repository_name
  depends_on = [
    helm_release.artifactory
  ]
}
