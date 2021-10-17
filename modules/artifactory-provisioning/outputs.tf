output "artifactory_regcred_vault_path" {
  value = vault_generic_secret.artifactory_regcred.path
}

output "artifactory_docker_user_vault_path" {
  value = module.docker_user.vault_path
}

output "artifactory_helm_user_vault_path" {
  value = module.helm_user.vault_path
}
