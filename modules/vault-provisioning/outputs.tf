output "vault_gitlab_approle_secret_path" {
  value = vault_generic_secret.gitlab_approle.path
}
