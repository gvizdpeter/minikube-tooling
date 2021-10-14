resource "vault_policy" "secrets_full_control" {
  name = "secrets-full-control"

  policy = <<EOT
    path "${var.vault_secrets_mountpoint}/*" {
      capabilities = ["create", "read", "update", "delete", "list"]
    }
  EOT
}

resource "vault_policy" "terraform_auth_token" {
  name = "terraform-auth-token"

  policy = <<EOT
    path "auth/token/create" {
      capabilities = ["update"]
    }
  EOT
}

resource "vault_auth_backend" "approle" {
  type = "approle"
}

resource "vault_approle_auth_backend_role" "gitlab_approle" {
  backend   = vault_auth_backend.approle.path
  role_name = "gitlab-approle"
  token_policies = [
    vault_policy.secrets_full_control.name,
    vault_policy.terraform_auth_token.name
  ]
}

resource "vault_approle_auth_backend_role_secret_id" "gitlab_approle_id" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.gitlab_approle.role_name
}

resource "vault_generic_secret" "gitlab_approle" {
  path = "${var.vault_secrets_mountpoint}/${local.vault_approle_secrets_path}/${vault_approle_auth_backend_role.gitlab_approle.role_name}"

  data_json = jsonencode({
    "role_id"   = "${vault_approle_auth_backend_role.gitlab_approle.role_id}"
    "secret_id" = "${vault_approle_auth_backend_role_secret_id.gitlab_approle_id.secret_id}"
  })
}
