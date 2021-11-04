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

variable "istio_ingress_gateway_name" {
  type = string
}

variable "routes" {
  type = list(object({
    service_name = string
    service_port = number
    prefix       = string
  }))
}

variable "name" {
  type = string
}
