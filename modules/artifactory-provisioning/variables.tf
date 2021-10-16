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

variable "artifactory_address" {
  type = string
}

variable "artifactory_admin_vault_path" {
  type = string
}

variable "vault_artifactory_secrets_path" {
  type = string
}

variable "artifactory_docker_virtual_repository_name" {
  type = string
}
