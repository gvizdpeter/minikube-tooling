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

variable "vault_domain" {
  type = string
}

variable "vault_subdomain" {
  type = string
}

variable "vault_unseal_key_base64" {
  type      = string
  sensitive = true
  default   = ""
}

variable "istio_ingress_gateway_name" {
  type = string
}
