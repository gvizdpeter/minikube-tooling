module "metrics_server" {
  source = "./modules/metrics-server"

  kubeconfig_path    = local.kubeconfig_path
  kubeconfig_context = local.kubeconfig_context
  namespace          = "kube-system"
}

module "keda" {
  source = "./modules/keda"

  kubeconfig_path    = local.kubeconfig_path
  kubeconfig_context = local.kubeconfig_context
  namespace          = "keda"
}

module "nfs_provisioner" {
  source = "./modules/nfs-provisioner"

  kubeconfig_path        = local.kubeconfig_path
  kubeconfig_context     = local.kubeconfig_context
  namespace              = "nfs-provisioner"
  nfs_server_host        = local.nfs_server_host
  nfs_server_path        = local.nfs_server_path
  nfs_storage_class_name = local.nfs_storage_class_name
}

module "istio" {
  source = "./modules/istio"

  kubeconfig_path    = local.kubeconfig_path
  kubeconfig_context = local.kubeconfig_context
  namespace          = "istio-system"
  domain             = local.domain
}

module "prometheus" {
  source = "./modules/prometheus"

  kubeconfig_path            = local.kubeconfig_path
  kubeconfig_context         = local.kubeconfig_context
  namespace                  = "prometheus"
  nfs_storage_class_name     = module.nfs_provisioner.nfs_storage_class_name
  prometheus_subdomain       = local.prometheus_subdomain
  prometheus_domain          = local.domain
  istio_ingress_gateway_name = module.istio.istio_ingress_gateway_name
}

module "vault_deployment" {
  source = "./modules/vault-deployment"

  kubeconfig_path            = local.kubeconfig_path
  kubeconfig_context         = local.kubeconfig_context
  namespace                  = "vault"
  nfs_storage_class_name     = module.nfs_provisioner.nfs_storage_class_name
  vault_unseal_key_base64    = "JzAdv8cdJvPEgTVAQ5A8sOSGZnF+f3azSb47E+dpjCM="
  vault_domain               = local.domain
  vault_subdomain            = local.vault_subdomain
  istio_ingress_gateway_name = module.istio.istio_ingress_gateway_name
}

module "vault_provisioning" {
  source = "./modules/vault-provisioning"

  vault_address            = module.vault_deployment.vault_address
  vault_admin_username     = module.vault_deployment.vault_admin_username
  vault_admin_password     = module.vault_deployment.vault_admin_password
  vault_secrets_mountpoint = module.vault_deployment.vault_secrets_mountpoint
}

module "postgresql" {
  source = "./modules/postgresql"

  kubeconfig_path          = local.kubeconfig_path
  kubeconfig_context       = local.kubeconfig_context
  vault_address            = module.vault_deployment.vault_address
  vault_admin_username     = module.vault_deployment.vault_admin_username
  vault_admin_password     = module.vault_deployment.vault_admin_password
  vault_secrets_mountpoint = module.vault_deployment.vault_secrets_mountpoint
  nfs_storage_class_name   = local.nfs_storage_class_name
  namespace                = "postgresql"
}

module "artifactory_deployment" {
  source = "./modules/artifactory-deployment"

  kubeconfig_path                              = local.kubeconfig_path
  kubeconfig_context                           = local.kubeconfig_context
  namespace                                    = "artifactory"
  nfs_storage_class_name                       = module.nfs_provisioner.nfs_storage_class_name
  vault_address                                = module.vault_deployment.vault_address
  vault_admin_username                         = module.vault_deployment.vault_admin_username
  vault_admin_password                         = module.vault_deployment.vault_admin_password
  vault_secrets_mountpoint                     = module.vault_deployment.vault_secrets_mountpoint
  postgresql_address                           = module.postgresql.postgresql_service_address
  postgresql_artifactory_database_vault_secret = module.postgresql.postgresql_artifactory_database_vault_secret
  artifactory_subdomain                        = local.artifactory_subdomain
  artifactory_domain                           = local.domain
  istio_ingress_gateway_name                   = module.istio.istio_ingress_gateway_name
  vault_artifactory_license_path               = local.vault_artifactory_license_path
}

module "artifactory_provisioning" {
  source = "./modules/artifactory-provisioning"

  vault_address                              = module.vault_deployment.vault_address
  vault_admin_username                       = module.vault_deployment.vault_admin_username
  vault_admin_password                       = module.vault_deployment.vault_admin_password
  vault_secrets_mountpoint                   = module.vault_deployment.vault_secrets_mountpoint
  artifactory_address                        = module.artifactory_deployment.artifactory_address
  artifactory_admin_vault_path               = module.artifactory_deployment.artifactory_admin_vault_path
  vault_artifactory_secrets_path             = module.artifactory_deployment.vault_artifactory_secrets_path
  artifactory_docker_virtual_repository_name = module.artifactory_deployment.artifactory_docker_virtual_repository_name
}

module "gitlab_deployment" {
  source = "./modules/gitlab-deployment"

  vault_address                           = module.vault_deployment.vault_address
  vault_admin_username                    = module.vault_deployment.vault_admin_username
  vault_admin_password                    = module.vault_deployment.vault_admin_password
  vault_secrets_mountpoint                = module.vault_deployment.vault_secrets_mountpoint
  postgresql_address                      = module.postgresql.postgresql_service_address
  postgresql_gitlab_database_vault_secret = module.postgresql.postgresql_gitlab_database_vault_secret
  kubeconfig_path                         = local.kubeconfig_path
  kubeconfig_context                      = local.kubeconfig_context
  namespace                               = "gitlab"
  nfs_storage_class_name                  = module.nfs_provisioner.nfs_storage_class_name
  gitlab_domain                           = local.domain
  gitlab_subdomain                        = local.gitlab_subdomain
  artifactory_regcred_vault_path          = module.artifactory_provisioning.artifactory_regcred_vault_path
  artifactory_address                     = module.artifactory_deployment.artifactory_address
  istio_ingress_gateway_name              = module.istio.istio_ingress_gateway_name
  istio_tls_ca_crt                        = module.istio.istio_tls_ca_crt
}

module "gitlab_provisioning" {
  source = "./modules/gitlab-provisioning"

  vault_address                      = module.vault_deployment.vault_address
  vault_admin_username               = module.vault_deployment.vault_admin_username
  vault_admin_password               = module.vault_deployment.vault_admin_password
  vault_secrets_mountpoint           = module.vault_deployment.vault_secrets_mountpoint
  artifactory_address                = module.artifactory_deployment.artifactory_address
  vault_gitlab_approle_secret_path   = module.vault_provisioning.vault_gitlab_approle_secret_path
  vault_gitlab_token_path            = local.vault_gitlab_token_path
  gitlab_address                     = module.gitlab_deployment.gitlab_address
  artifactory_docker_user_vault_path = module.artifactory_provisioning.artifactory_docker_user_vault_path
  artifactory_helm_user_vault_path   = module.artifactory_provisioning.artifactory_helm_user_vault_path
}
