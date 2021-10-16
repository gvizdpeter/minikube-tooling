module "docker_user" {
  source = "./modules/artifactory-user"

  username     = "docker-user"
  email_domain = local.artifactory_hostname
  vault_path   = "${var.vault_secrets_mountpoint}/${var.vault_artifactory_secrets_path}"
  groups = [
    artifactory_group.docker_users.name,
  ]
}

module "helm_user" {
  source = "./modules/artifactory-user"

  username     = "helm-user"
  email_domain = local.artifactory_hostname
  vault_path   = "${var.vault_secrets_mountpoint}/${var.vault_artifactory_secrets_path}"
  groups = [
    artifactory_group.helm_users.name,
  ]
}
