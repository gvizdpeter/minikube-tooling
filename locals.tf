locals {
  domain                         = "minikube.com"
  http_secured                   = false
  ingess_class_name              = "nginx"
  nfs_server_host                = "host.minikube.internal"
  nfs_server_path                = "/home/peter/minikube-nfs"
  nfs_storage_class_name         = "nfs-client"
  vault_subdomain                = "vault"
  kubeconfig_path                = "~/.kube/config"
  kubeconfig_context             = "minikube"
  artifactory_hostname           = "artifactory.minikube.com"
  vault_artifactory_license_path = "artifactory/license"
  gitlab_domain                  = "minikube.com"
  vault_gitlab_token_path        = "gitlab/root-token"
  prometheus_subdomain           = "prometheus"
}
