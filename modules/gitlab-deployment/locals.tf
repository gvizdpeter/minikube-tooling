locals {
  gitlab_root_password_secret_key                = "gitlab-root-password"
  gitlab_secrets_vault_path                      = "gitlab"
  gitlab_root_username                           = "root"
  postgresql_address                             = regex("^[^:]+", var.postgresql_address)
  postgresql_port                                = regex("[0-9]+$", var.postgresql_address)
  postgresql_gitlab_database_password_secret_key = "postgresql-gitlab-database-password"
  gitlab_runner_registration_token_secret_key    = "runner-registration-token"
  gitlab_minio_access_key                        = "accesskey"
  gitlab_minio_secret_key                        = "secretkey"
}