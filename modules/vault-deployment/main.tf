resource "kubernetes_namespace" "vault" {
  metadata {
    name = var.namespace
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
    name = "vault-init-script"
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

resource "helm_release" "vault" {
  name          = "vault"
  repository    = "https://helm.releases.hashicorp.com"
  chart         = "vault"
  version       = "0.16.1"
  namespace     = kubernetes_namespace.vault.metadata[0].name
  recreate_pods = true

  values = [
    templatefile("${path.module}/values/vault.yaml", {
      storage_class_name                  = var.nfs_storage_class_name
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

resource "kubernetes_manifest" "vault_ingress" {
  manifest = {
    "apiVersion" = "networking.k8s.io/v1"
    "kind"       = "Ingress"
    "metadata" = {
      "annotations" = {
        "kubernetes.io/ingress.class" = var.ingress_class
      }
      "name"      = "vault-ingress"
      "namespace" = helm_release.vault.namespace
    }
    "spec" = {
      "rules" = [
        {
          "host" = var.vault_hostname
          "http" = {
            "paths" = [
              {
                "backend" = {
                  "service" = {
                    "name" = "vault-ui"
                    "port" = {
                      "number" = 8200
                    }
                  }
                }
                "path"     = "/"
                "pathType" = "Prefix"
              },
            ]
          }
        },
      ]
    }
  }
}