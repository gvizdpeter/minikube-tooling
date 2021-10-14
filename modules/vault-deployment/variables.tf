variable "kubeconfig_path" {
  type = string
}

variable "kubeconfig_context" {
  type = string
}

variable "namespace" {
  type = string
}

variable "nfs_storage_class_name" {
  type = string
}

variable "vault_hostname" {
  type = string
}

variable "vault_unseal_key_base64" {
  type      = string
  sensitive = true
  default   = ""
}

variable "ingress_class" {
  type = string
}
