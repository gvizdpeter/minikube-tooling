provider "kubectl" {
  config_path    = var.kubeconfig_path
  config_context = var.kubeconfig_context
}