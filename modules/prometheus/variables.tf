variable "namespace" {
  type = string
}

variable "kubeconfig_path" {
  type = string
}

variable "kubeconfig_context" {
  type = string
}

variable "nfs_storage_class_name" {
  type = string
}

variable "prometheus_hostname" {
  type = string
}

variable "ingress_class" {
  type = string
}
