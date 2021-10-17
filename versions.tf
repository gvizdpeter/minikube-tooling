terraform {
  required_version = "~> 1.0.0"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 2.24.0"
    }
    artifactory = {
      source  = "jfrog/artifactory"
      version = "~> 2.2.0"
    }
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "~> 3.7.0"
    }
  }
}