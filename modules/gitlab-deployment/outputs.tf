output "gitlab_address" {
  value = "${var.http_secured ? "https" : "http"}://${local.gitlab_chart_name}.${var.gitlab_domain}"
  depends_on = [
    helm_release.gitlab
  ]
}
