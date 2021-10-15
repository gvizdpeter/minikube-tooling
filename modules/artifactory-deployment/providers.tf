provider "vault" {
  address = var.vault_address

  auth_login {
    path = "auth/userpass/login/${var.vault_admin_username}"

    parameters = {
      password = var.vault_admin_password
    }
  }
}

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
