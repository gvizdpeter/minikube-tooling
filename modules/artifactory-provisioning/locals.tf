locals {
  artifactory_docker_user = "docker-user"
  artifactory_hostname    = regex("[^/]+$", var.artifactory_address)
  vault_regcred_path      = "regcred"
}
