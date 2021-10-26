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

variable "gitlab_domain" {
  type = string
}

variable "gitlab_subdomain" {
  type = string
}

variable "postgresql_gitlab_database_vault_secret" {
  type = string
}

variable "postgresql_address" {
  type = string
}

/*variable "artifactory_regcred_vault_path" {
  type = string
}

variable "artifactory_address" {
  type = string
}*/

variable "istio_ingress_gateway_name" {
  type = string
}

variable "istio_tls_ca_crt" {
  type = string
}
