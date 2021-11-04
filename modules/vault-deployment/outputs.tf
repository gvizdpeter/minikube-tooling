output "vault_admin_username" {
  value     = random_password.vault_admin_password.keepers["username"]
  sensitive = true
  depends_on = [
    helm_release.vault
  ]
}

output "vault_admin_password" {
  value     = random_password.vault_admin_password.result
  sensitive = true
  depends_on = [
    helm_release.vault
  ]
}

output "vault_secrets_mountpoint" {
  value = local.vault_secrets_mountpoint
  depends_on = [
    helm_release.vault
  ]
}

output "vault_address" {
  value = "https://${var.vault_subdomain}.${var.vault_domain}"
  depends_on = [
    helm_release.vault
  ]
}
