output "password" {
  value     = random_password.artifactory_user_password.result
  sensitive = true
}

output "username" {
  value     = random_password.artifactory_user_password.keepers["username"]
  sensitive = true
}

output "vault_path" {
  value = vault_generic_secret.artifactory_user.path
}
