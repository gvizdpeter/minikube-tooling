provider "helm" {
  kubernetes {
    config_path    = var.kubeconfig_path
    config_context = var.kubeconfig_context
  }
}

provider "kubernetes" {
  experiments {
    manifest_resource = true
  }

  config_path    = var.kubeconfig_path
  config_context = var.kubeconfig_context
}