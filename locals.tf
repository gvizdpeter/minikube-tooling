locals {
  http_secured                   = false
  ingess_class_name              = "nginx"
  nfs_server_host                = "host.minikube.internal"
  nfs_server_path                = "/home/peter/minikube-nfs"
  nfs_storage_class_name         = "nfs-client"
  vault_hostname                 = "vault.minikube.com"
  vault_secrets_mountpoint       = "secrets"
  vault_approle_mountpoint       = "approle"
  vault_user_mountpoint          = "user"
  container_registry_host        = "container-registry"
  kubeconfig_path                = "~/.kube/config"
  kubeconfig_context             = "minikube"
  artifactory_hostname           = "artifactory.minikube.com"
  vault_artifactory_license_path = "artifactory/license"
}
