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
