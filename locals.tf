locals {
  kubeconfig_path                = "~/.kube/config"
  kubeconfig_context             = "minikube"
  nfs_server_host                = "host.minikube.internal"
  nfs_server_path                = "/home/peter/minikube-nfs"
  nfs_storage_class_name         = "nfs-client"
  domain                         = "minikube.com"
  vault_subdomain                = "vault"
  artifactory_subdomain          = "artifactory"
  gitlab_subdomain               = "gitlab"
  prometheus_subdomain           = "prometheus"
  vault_artifactory_license_path = "artifactory/license"
  vault_gitlab_token_path        = "gitlab/root-token"
}
