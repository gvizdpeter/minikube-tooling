# Docker repositories

resource "artifactory_local_repository" "docker_local" {
  key             = "docker-local"
  package_type    = "docker"
  repo_layout_ref = "simple-default"
}

resource "artifactory_remote_repository" "docker_remote_docker" {
  key                            = "docker-remote-docker"
  package_type                   = "docker"
  url                            = "https://registry-1.docker.io/"
  repo_layout_ref                = "simple-default"
  enable_token_authentication    = true
  retrieval_cache_period_seconds = 1209600
}

resource "artifactory_remote_repository" "docker_remote_google" {
  key                            = "docker-remote-google"
  package_type                   = "docker"
  url                            = "https://gcr.io/"
  repo_layout_ref                = "simple-default"
  enable_token_authentication    = true
  retrieval_cache_period_seconds = 1209600
}

resource "artifactory_virtual_repository" "docker_virtual" {
  key             = var.artifactory_docker_virtual_repository_name
  package_type    = "docker"
  repo_layout_ref = "simple-default"
  repositories = [
    artifactory_local_repository.docker_local.key,
    artifactory_remote_repository.docker_remote_docker.key,
    artifactory_remote_repository.docker_remote_google.key,
  ]
  default_deployment_repo = artifactory_local_repository.docker_local.key
}

# Helm repositories

resource "artifactory_local_repository" "helm_local" {
  key             = "helm-local"
  package_type    = "helm"
  repo_layout_ref = "simple-default"
}

resource "artifactory_virtual_repository" "helm_virtual" {
  key             = "helm-virtual"
  package_type    = "helm"
  repo_layout_ref = "simple-default"
  repositories = [
    artifactory_local_repository.helm_local.key,
  ]
  default_deployment_repo = artifactory_local_repository.helm_local.key
}
