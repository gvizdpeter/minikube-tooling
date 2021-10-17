provider "vault" {
  address = var.vault_address

  auth_login {
    path = "auth/userpass/login/${var.vault_admin_username}"

    parameters = {
      password = var.vault_admin_password
    }
  }
}

provider "gitlab" {
  token    = data.vault_generic_secret.gitlab_token.data["token"]
  base_url = "${var.gitlab_address}/api/v4/"
}

terraform {
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "~> 3.7.0"
    }
  }
}
