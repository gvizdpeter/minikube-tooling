resource "kubernetes_namespace" "gitlab" {
  metadata {
    name = var.namespace
    labels = {
      istio-injection = "enabled"
    }
  }
}

resource "random_password" "gitlab_root_password" {
  length  = 16
  special = false
  upper   = true
  lower   = true
  number  = true
  keepers = {
    "username" = local.gitlab_root_username
  }
}

resource "vault_generic_secret" "gitlab_root_account" {
  path = "${var.vault_secrets_mountpoint}/${local.gitlab_secrets_vault_path}/root"

  data_json = jsonencode({
    "username" = "${random_password.gitlab_root_password.keepers["username"]}"
    "password" = "${random_password.gitlab_root_password.result}"
  })
}

resource "kubernetes_secret" "gitlab_root_password" {
  metadata {
    name      = "gitlab-root-password"
    namespace = kubernetes_namespace.gitlab.metadata[0].name
    labels    = local.gitlab_secret_labels
  }

  data = {
    "${local.gitlab_root_password_secret_key}" = "${random_password.gitlab_root_password.result}"
  }

  type = "Opaque"
}

data "vault_generic_secret" "postgresql_gitlab_database_vault" {
  path = var.postgresql_gitlab_database_vault_secret
}

resource "kubernetes_secret" "postgresql_gitlab_database_password_secret" {
  metadata {
    name      = "postgresql-gitlab-database-password-secret"
    namespace = kubernetes_namespace.gitlab.metadata[0].name
  }

  data = {
    "${local.postgresql_gitlab_database_password_secret_key}" = "${data.vault_generic_secret.postgresql_gitlab_database_vault.data["password"]}"
  }

  type = "Opaque"
}

resource "random_password" "gitlab_runner_registration_token" {
  length  = 20
  special = false
  upper   = true
  lower   = true
  number  = true
}

resource "vault_generic_secret" "gitlab_runner_registration_token" {
  path = "${var.vault_secrets_mountpoint}/${local.gitlab_secrets_vault_path}/runner-registration-token"

  data_json = jsonencode({
    "token" = "${random_password.gitlab_runner_registration_token.result}"
  })
}

resource "kubernetes_secret" "gitlab_runner_registration_token" {
  metadata {
    name      = "gitlab-runner-registration-token"
    namespace = kubernetes_namespace.gitlab.metadata[0].name
    labels    = local.gitlab_secret_labels
  }

  data = {
    "${local.gitlab_runner_registration_token_secret_key}" = "${random_password.gitlab_runner_registration_token.result}"
    "${local.gitlab_runner_token_secret_key}"              = ""
  }

  type = "Opaque"
}

data "vault_generic_secret" "artifactory_regcred_vault_path" {
  path = var.artifactory_regcred_vault_path
}

resource "kubernetes_secret" "artifactory_regcred" {
  metadata {
    name      = "artifactory-regcred"
    namespace = kubernetes_namespace.gitlab.metadata[0].name
  }

  data = {
    "${local.regcred_secret_key}" = "${data.vault_generic_secret.artifactory_regcred_vault_path.data[local.regcred_secret_key]}"
  }

  type = "kubernetes.io/dockerconfigjson"
}

module "gitlab_pvc" {
  source = "./../pvc"

  namespace          = kubernetes_namespace.gitlab.metadata[0].name
  name               = "repo-data-gitlab-gitaly-0"
  size               = "1Gi"
  kubeconfig_path    = var.kubeconfig_path
  kubeconfig_context = var.kubeconfig_context
  storage_class_name = var.nfs_storage_class_name
}

resource "kubernetes_secret" "istio_tls_ca_crt" {
  metadata {
    name      = "istio-tls-ca-crt"
    namespace = kubernetes_namespace.gitlab.metadata[0].name
  }

  data = {
    "${var.gitlab_subdomain}.${var.gitlab_domain}.crt" = var.istio_tls_ca_crt
  }

  type = "Opaque"
}


resource "helm_release" "gitlab" {
  name          = local.gitlab_chart_name
  chart         = "${path.module}/charts/gitlab"
  namespace     = kubernetes_namespace.gitlab.metadata[0].name
  recreate_pods = true
  timeout       = 600

  values = [
    templatefile("${path.module}/values/gitlab.yaml", {
      release_name                                   = local.gitlab_chart_name
      gitlab_domain                                  = var.gitlab_domain
      gitlab_subdomain                               = var.gitlab_subdomain
      gitlab_root_password_secret                    = kubernetes_secret.gitlab_root_password.metadata[0].name
      gitlab_root_password_secret_key                = local.gitlab_root_password_secret_key
      postgresql_address                             = local.postgresql_address
      postgresql_port                                = local.postgresql_port
      postgresql_gitlab_database_username            = data.vault_generic_secret.postgresql_gitlab_database_vault.data["username"]
      postgresql_gitlab_database_name                = data.vault_generic_secret.postgresql_gitlab_database_vault.data["database"]
      postgresql_gitlab_database_password_secret     = kubernetes_secret.postgresql_gitlab_database_password_secret.metadata[0].name
      postgresql_gitlab_database_password_secret_key = local.postgresql_gitlab_database_password_secret_key
      gitlab_runner_registration_token_secret        = kubernetes_secret.gitlab_runner_registration_token.metadata[0].name
      gitlab_minio_secret                            = kubernetes_secret.gitlab_minio_secret.metadata[0].name
      gitlab_redis_password_secret                   = kubernetes_secret.gitlab_redis_password.metadata[0].name
      gitlab_redis_password_secret_key               = local.gitlab_redis_password_secret_key
      regcred_secret                                 = kubernetes_secret.artifactory_regcred.metadata[0].name
      regcred_secret_key                             = local.regcred_secret_key
      namespace                                      = kubernetes_namespace.gitlab.metadata[0].name
      gitlab_pvc_name                                = module.gitlab_pvc.name
      minio_pvc_name                                 = module.minio_pvc.name
      redis_pvc_name                                 = module.redis_pvc.name
      istio_tls_ca_crt_secret                        = kubernetes_secret.istio_tls_ca_crt.metadata[0].name
    })
  ]
}

module "gitlab_virtual_service" {
  source = "./../istio-virtual-service"

  name      = "gitlab"
  namespace = kubernetes_namespace.gitlab.metadata[0].name
  domain    = var.gitlab_domain
  subdomain = var.gitlab_subdomain
  routes = [
    {
      service_name = "gitlab-webservice-default"
      service_port = 8181
      prefix       = "/"
    },
    {
      service_name = "gitlab-webservice-default"
      service_port = 8080
      prefix       = "/admin/sidekiq"
    }
  ]
  istio_ingress_gateway_name = var.istio_ingress_gateway_name
  kubeconfig_path            = var.kubeconfig_path
  kubeconfig_context         = var.kubeconfig_context
}

module "gitlab_runner_scaled_object" {
  source = "./../keda-scaled-object"

  name               = "gitlab-runner"
  namespace          = kubernetes_namespace.gitlab.metadata[0].name
  kubeconfig_path    = var.kubeconfig_path
  kubeconfig_context = var.kubeconfig_context
  scaled_deployment  = "${local.gitlab_chart_name}-gitlab-runner"
  prometheus_address = var.prometheus_address
  metric_name        = "ci_pending_builds"
  threshold          = 1
  query              = "sum(ci_pending_builds) or vector(0)"
}