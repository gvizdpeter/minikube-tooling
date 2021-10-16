locals {
  artifactory_admin_username                   = "admin"
  vault_artifactory_secrets_path               = "artifactory"
  master_key_secret_key                        = "master-key"
  join_key_secret_key                          = "join-key"
  admin_creds_secret_key                       = "admin-creds"
  master_key                                   = sha256(random_password.artifactory_master_key.result)
  join_key                                     = sha256(random_password.artifactory_join_key.result)
  postgresql_artifactory_database_url_key      = "postgresql-artifactory-database-url"
  postgresql_artifactory_database_username_key = "postgresql-artifactory-database-username"
  postgresql_artifactory_database_password_key = "postgresql-artifactory-database-password"
  artifactory_docker_virtual_repository_name   = "docker-virtual"
  artifactory_license_secret_key               = "artifactory-license"
}
