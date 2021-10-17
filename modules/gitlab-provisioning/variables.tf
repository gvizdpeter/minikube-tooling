variable "vault_address" {
  type = string
}

variable "vault_admin_username" {
  type = string
}

variable "vault_admin_password" {
  type = string
}

variable "vault_secrets_mountpoint" {
  type = string
}

variable "vault_gitlab_approle_secret_path" {
  type = string
}

variable "vault_gitlab_token_path" {
  type = string
}

variable "gitlab_address" {
  type = string
}

variable "artifactory_address" {
  type = string
}

variable "artifactory_docker_user_vault_path" {
  type = string
}

variable "artifactory_helm_user_vault_path" {
  type = string
}
