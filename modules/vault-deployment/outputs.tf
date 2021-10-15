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
  value = "${var.http_secured ? "https" : "http"}://${var.vault_hostname}"
  depends_on = [
    helm_release.vault
  ]
}
