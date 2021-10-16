resource "artifactory_permission_target" "docker_users" {
  name = "docker-users"

  repo {
    includes_pattern = ["**"]

    repositories = [
      artifactory_local_repository.docker_local.key,
      artifactory_remote_repository.docker_remote_docker.key,
      artifactory_remote_repository.docker_remote_google.key,
    ]

    actions {
      groups {
        name        = artifactory_group.docker_users.name
        permissions = ["read", "delete", "write", "annotate"]
      }
    }
  }
}

resource "artifactory_permission_target" "helm_users" {
  name = "helm-users"

  repo {
    includes_pattern = ["**"]

    repositories = [
      artifactory_local_repository.helm_local.key,
    ]

    actions {
      groups {
        name        = artifactory_group.helm_users.name
        permissions = ["read", "delete", "write", "annotate"]
      }
    }
  }
}
