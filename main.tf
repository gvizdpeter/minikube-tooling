module "ingress_nginx" {
  source = "./modules/ingress-nginx"

  kubeconfig_path    = local.kubeconfig_path
  kubeconfig_context = local.kubeconfig_context
  namespace          = "ingress-nginx"
  ingess_class_name  = local.ingess_class_name
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

module "vault_deployment" {
  source = "./modules/vault-deployment"

  kubeconfig_path         = local.kubeconfig_path
  kubeconfig_context      = local.kubeconfig_context
  namespace               = "vault"
  nfs_storage_class_name  = module.nfs_provisioner.nfs_storage_class_name
  vault_hostname          = local.vault_hostname
  ingress_class           = module.ingress_nginx.ingress_class
  vault_unseal_key_base64 = "yHj8F8zr+KfmbNLFDzF02uB2QWn1vJR+YMbPWkFrvWs="
}

module "vault_provisioning" {
  source = "./modules/vault-provisioning"

  vault_address = "${local.vault_protocol}://${local.vault_hostname}"
  vault_admin_username = module.vault_deployment.vault_admin_username
  vault_admin_password = module.vault_deployment.vault_admin_password
  vault_secrets_mountpoint = module.vault_deployment.vault_secrets_mountpoint
}

module "postgresql" {
  source = "./modules/postgresql"

  kubeconfig_path         = local.kubeconfig_path
  kubeconfig_context      = local.kubeconfig_context
  vault_address = "${local.vault_protocol}://${local.vault_hostname}"
  vault_admin_username = module.vault_deployment.vault_admin_username
  vault_admin_password = module.vault_deployment.vault_admin_password
  vault_secrets_mountpoint = module.vault_deployment.vault_secrets_mountpoint
  nfs_storage_class_name = local.nfs_storage_class_name
  namespace = "postgresql"
}
