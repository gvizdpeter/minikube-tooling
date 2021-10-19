locals {
  http_secured                   = false
  ingess_class_name              = "nginx"
  nfs_server_host                = "host.minikube.internal"
  nfs_server_path                = "/home/peter/minikube-nfs"
  nfs_storage_class_name         = "nfs-client"
  vault_hostname                 = "vault.minikube.com"
  kubeconfig_path                = "~/.kube/config"
  kubeconfig_context             = "minikube"
  artifactory_hostname           = "artifactory.minikube.com"
  vault_artifactory_license_path = "artifactory/license"
  gitlab_domain                  = "minikube.com"
  vault_gitlab_token_path        = "gitlab/root-token"
  prometheus_hostname            = "prometheus.minikube.com"
}
