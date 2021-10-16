resource "artifactory_group" "docker_users" {
  name             = "docker-users"
  admin_privileges = false
  auto_join        = false
}

resource "artifactory_group" "helm_users" {
  name             = "helm-users"
  admin_privileges = false
  auto_join        = false
}
