variable "kubeconfig_path" {
  type = string
}

variable "kubeconfig_context" {
  type = string
}

variable "name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "storage_class_name" {
  type = string
}

variable "size" {
  type = string
}

variable "access_modes" {
  type    = list(string)
  default = ["ReadWriteOnce"]
}
