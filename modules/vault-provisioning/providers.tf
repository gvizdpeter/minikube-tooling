provider "vault" {
  address = var.vault_address

  auth_login {
    path = "auth/userpass/login/${var.vault_admin_username}"

    parameters = {
      password = var.vault_admin_password
    }
  }
}
