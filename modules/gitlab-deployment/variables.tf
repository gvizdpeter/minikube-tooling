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

variable "http_secured" {
  type = bool
}

variable "gitlab_hostname" {
  type = string
}

variable "postgresql_gitlab_database_secret" {
  type = object({
    name         = string
    namespace    = string
    username_key = string
    password_key = string
    database_key = string
  })
}

variable "postgresql_address" {
  type = string
}

variable "ingress_class" {
  type = string
}
