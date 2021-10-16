provider "vault" {
  address = var.vault_address

  auth_login {
    path = "auth/userpass/login/${var.vault_admin_username}"

    parameters = {
      password = var.vault_admin_password
    }
  }
}

terraform {
  required_providers {
    artifactory = {
      source  = "jfrog/artifactory"
      version = "~> 2.2.0"
    }
  }
}

provider "artifactory" {
  url      = var.artifactory_address
  username = data.vault_generic_secret.artifactory_admin.data["username"]
  password = data.vault_generic_secret.artifactory_admin.data["password"]
}
