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

variable "prometheus_subdomain" {
  type = string
}

variable "prometheus_domain" {
  type = string
}

variable "istio_ingress_gateway_name" {
  type = string
}
