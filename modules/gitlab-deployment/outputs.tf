output "gitlab_address" {
  value = "https://${var.gitlab_subdomain}.${var.gitlab_domain}"
  depends_on = [
    helm_release.gitlab
  ]
}
