locals {
  vault_unseal_key_base64_secret_key = "VAULT_UNSEAL_KEY_BASE64"
  vault_admin_username_secret_key    = "VAULT_ADMIN_USERNAME"
  vault_admin_password_secret_key    = "VAULT_ADMIN_PASSWORD"
  vault_admin_username               = "admin"
  vault_init_script_name             = "vault-init-script.sh"
  vault_admin_policy_name            = "vault-admin-policy.hcl"
  vault_secrets_mountpoint           = "secret"
}
