resource "kubernetes_namespace" "vault" {
  metadata {
    name = var.namespace
    labels = {
      istio-injection = "enabled"
    }
  }
}

resource "kubernetes_secret" "vault_unseal_key" {
  metadata {
    name      = "vault-unseal-key"
    namespace = kubernetes_namespace.vault.metadata[0].name
  }

  data = {
    "${local.vault_unseal_key_base64_secret_key}" = "${var.vault_unseal_key_base64}"
  }

  type = "Opaque"
}

resource "random_password" "vault_admin_password" {
  length  = 16
  special = false
  upper   = true
  lower   = true
  number  = true
  keepers = {
    "username" = local.vault_admin_username
  }
}

resource "kubernetes_secret" "vault_admin" {
  metadata {
    name      = "vault-admin"
    namespace = kubernetes_namespace.vault.metadata[0].name
  }

  data = {
    "${local.vault_admin_username_secret_key}" = "${random_password.vault_admin_password.keepers["username"]}"
    "${local.vault_admin_password_secret_key}" = "${random_password.vault_admin_password.result}"
  }

  type = "Opaque"
}

resource "kubernetes_config_map" "vault_init_configmap" {
  metadata {
    name      = "vault-init-script"
    namespace = kubernetes_namespace.vault.metadata[0].name
  }

  data = {
    "${local.vault_init_script_name}" = "${templatefile("${path.module}/init/vault-init-script.sh", {
      vault_secrets_mountpoint = local.vault_secrets_mountpoint
    })}"
    "${local.vault_admin_policy_name}" = "${templatefile("${path.module}/init/vault-admin-policy.hcl", {
      vault_secrets_mountpoint = local.vault_secrets_mountpoint
    })}"
  }
}

module "vault_pvc" {
  source = "./../pvc"

  namespace          = kubernetes_namespace.vault.metadata[0].name
  name               = "vault-pvc"
  size               = "1Gi"
  kubeconfig_path    = var.kubeconfig_path
  kubeconfig_context = var.kubeconfig_context
  storage_class_name = var.nfs_storage_class_name
}

resource "helm_release" "vault" {
  name          = "vault"
  repository    = "https://helm.releases.hashicorp.com"
  chart         = "vault"
  version       = "0.16.1"
  namespace     = kubernetes_namespace.vault.metadata[0].name
  recreate_pods = true

  values = [
    templatefile("${path.module}/values/vault.yaml", {
      pvc_name                            = module.vault_pvc.name
      vault_unseal_key_base64_secret_name = kubernetes_secret.vault_unseal_key.metadata[0].name
      vault_unseal_key_base64_secret_key  = local.vault_unseal_key_base64_secret_key
      vault_admin_secret_name             = kubernetes_secret.vault_admin.metadata[0].name
      vault_admin_username_secret_key     = local.vault_admin_username_secret_key
      vault_admin_password_secret_key     = local.vault_admin_password_secret_key
      vault_init_configmap_name           = kubernetes_config_map.vault_init_configmap.metadata[0].name
      vault_init_script_name              = local.vault_init_script_name
      vault_admin_policy_name             = local.vault_admin_policy_name
    })
  ]
}

module "vault_virtual_service" {
  source = "./../istio-virtual-service"

  name      = "vault"
  namespace = kubernetes_namespace.vault.metadata[0].name
  domain    = var.vault_domain
  subdomain = var.vault_subdomain
  routes = [{
    service_name = "vault"
    service_port = 8200
    prefix       = "/"
  }]
  istio_ingress_gateway_name = var.istio_ingress_gateway_name
  kubeconfig_path            = var.kubeconfig_path
  kubeconfig_context         = var.kubeconfig_context
}
