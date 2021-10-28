locals {
  gitlab_root_password_secret_key                = "gitlab-root-password"
  gitlab_secrets_vault_path                      = "gitlab"
  gitlab_root_username                           = "root"
  postgresql_address                             = regex("^[^:]+", var.postgresql_address)
  postgresql_port                                = regex("[0-9]+$", var.postgresql_address)
  postgresql_gitlab_database_password_secret_key = "postgresql-gitlab-database-password"
  gitlab_runner_registration_token_secret_key    = "runner-registration-token"
  gitlab_runner_token_secret_key                 = "runner-token"
  gitlab_minio_access_key                        = "accesskey"
  gitlab_minio_secret_key                        = "secretkey"
  gitlab_redis_password_secret_key               = "redis-password"
  regcred_secret_key                             = ".dockerconfigjson"
  docker_daemon_configmap_key                    = "daemon.json"
  gitlab_chart_name                              = "gitlab"
  gitlab_chart_version                           = "5.4.0"
  gitlab_secret_labels = {
    "app"      = local.gitlab_chart_name
    "chart"    = "${local.gitlab_chart_name}-${local.gitlab_chart_version}"
    "heritage" = "Helm"
    "release"  = local.gitlab_chart_name
  }
}