data "vault_generic_secret" "gitlab_token" {
  path = "${var.vault_secrets_mountpoint}/${var.vault_gitlab_token_path}"
}

data "vault_generic_secret" "vault_approle" {
  path = var.vault_gitlab_approle_secret_path
}

data "vault_generic_secret" "artifactory_docker_user" {
  path = var.artifactory_docker_user_vault_path
}

data "vault_generic_secret" "artifactory_helm_user" {
  path = var.artifactory_helm_user_vault_path
}

resource "gitlab_instance_variable" "vault_address" {
  key   = "VAULT_ADDR"
  value = var.vault_address
}

resource "gitlab_instance_variable" "vault_role_id" {
  key    = "VAULT_ROLE_ID"
  value  = data.vault_generic_secret.vault_approle.data["role-id"]
  masked = true
}

resource "gitlab_instance_variable" "vault_secret_id" {
  key    = "VAULT_SECRET_ID"
  value  = data.vault_generic_secret.vault_approle.data["secret-id"]
  masked = true
}

resource "gitlab_instance_variable" "artifactory_url" {
  key   = "ARTIFACTORY_URL"
  value = var.artifactory_address
}

resource "gitlab_instance_variable" "artifactory_docker_username" {
  key   = "ARTIFACTORY_DOCKER_USERNAME"
  value = data.vault_generic_secret.artifactory_docker_user.data["username"]
}

resource "gitlab_instance_variable" "artifactory_docker_password" {
  key    = "ARTIFACTORY_DOCKER_PASSWORD"
  value  = data.vault_generic_secret.artifactory_docker_user.data["password"]
  masked = true
}

resource "gitlab_instance_variable" "artifactory_helm_username" {
  key   = "ARTIFACTORY_HELM_USERNAME"
  value = data.vault_generic_secret.artifactory_helm_user.data["username"]
}

resource "gitlab_instance_variable" "artifactory_helm_password" {
  key    = "ARTIFACTORY_HELM_PASSWORD"
  value  = data.vault_generic_secret.artifactory_helm_user.data["password"]
  masked = true
}
