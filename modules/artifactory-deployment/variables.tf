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

variable "nfs_storage_class_name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "kubeconfig_path" {
  type = string
}

variable "kubeconfig_context" {
  type = string
}

variable "postgresql_address" {
  type = string
}

variable "postgresql_artifactory_database_vault_secret" {
  type = string
}

variable "artifactory_hostname" {
  type = string
}

variable "ingress_class" {
  type = string
}

variable "http_secured" {
  type = bool
}

variable "vault_artifactory_license_path" {
  type = string
}
