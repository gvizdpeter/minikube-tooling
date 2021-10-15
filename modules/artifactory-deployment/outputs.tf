output "artifactory_admin_username" {
  value     = random_password.artifactory_admin_password.keepers["username"]
  sensitive = true
  depends_on = [
    helm_release.artifactory
  ]
}

output "artifactory_admin_password" {
  value     = random_password.artifactory_admin_password.result
  sensitive = true
  depends_on = [
    helm_release.artifactory
  ]
}

output "artifactory_address" {
  value = "${var.http_secured ? "https" : "http"}://${var.artifactory_hostname}"
  depends_on = [
    helm_release.artifactory
  ]
}
