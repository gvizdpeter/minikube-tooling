resource "vault_generic_secret" "artifactory_regcred" {
  path = "${var.vault_secrets_mountpoint}/${var.vault_artifactory_secrets_path}/${local.vault_regcred_path}"

  data_json = jsonencode({
    ".dockerconfigjson" = "${templatefile("${path.module}/regcred/dockerconfig.json", {
      repository_url = local.artifactory_hostname
      basic_auth     = base64encode("${module.docker_user.username}:${module.docker_user.password}")
    })}"
  })
}
