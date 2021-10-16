data "vault_generic_secret" "artifactory_admin" {
  path = var.artifactory_admin_vault_path
}
