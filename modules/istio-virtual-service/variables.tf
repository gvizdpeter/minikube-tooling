variable "kubeconfig_path" {
  type = string
}

variable "kubeconfig_context" {
  type = string
}

variable "namespace" {
  type = string
}

variable "domain" {
  type = string
}

variable "subdomain" {
  type = string
}

variable "service_name" {
  type = string
}

variable "service_port" {
  type = number
}

variable "istio_ingress_gateway_name" {
  type = string
}