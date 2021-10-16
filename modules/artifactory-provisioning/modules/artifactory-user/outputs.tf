output "password" {
  value     = random_password.artifactory_docker_user_password.result
  sensitive = true
}

output "username" {
  value     = random_password.artifactory_docker_user_password.keepers["username"]
  sensitive = true
}
