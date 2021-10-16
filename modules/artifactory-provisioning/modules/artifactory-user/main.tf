resource "random_password" "artifactory_docker_user_password" {
  length  = 16
  special = false
  upper   = true
  lower   = true
  number  = true
  keepers = {
    "username" = var.username
  }
}

resource "vault_generic_secret" "artifactory_docker_user" {
  path = "${var.vault_path}/${random_password.artifactory_docker_user_password.keepers["username"]}"

  data_json = jsonencode({
    "username" = "${random_password.artifactory_docker_user_password.keepers["username"]}"
    "password" = "${random_password.artifactory_docker_user_password.result}"
  })
}

resource "artifactory_user" "docker_user" {
  name              = random_password.artifactory_docker_user_password.keepers["username"]
  email             = "${random_password.artifactory_docker_user_password.keepers["username"]}@${var.email_domain}"
  groups            = concat(["readers"], var.groups)
  password          = random_password.artifactory_docker_user_password.result
  admin             = false
  profile_updatable = false
  disable_ui_access = false
}
