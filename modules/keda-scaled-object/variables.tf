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

variable "scaled_deployment" {
  type = string
}

variable "polling_interval" {
  type    = number
  default = 15
}

variable "cooldown_period" {
  type    = number
  default = 300
}

variable "min_replica_count" {
  type    = number
  default = 0
}

variable "max_replica_count" {
  type    = number
  default = 110
}

variable "prometheus_address" {
  type = string
}

variable "metric_name" {
  type = string
}

variable "threshold" {
  type = number
}

variable "query" {
  type = string
}
