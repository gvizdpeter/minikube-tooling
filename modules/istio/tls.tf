resource "tls_private_key" "ca_key" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "ca_crt" {
  key_algorithm         = "RSA"
  private_key_pem       = tls_private_key.ca_key.private_key_pem
  is_ca_certificate     = true
  validity_period_hours = 87600
  allowed_uses = [
    "cert_signing",
    "key_encipherment",
    "digital_signature",
  ]

  subject {
    common_name  = var.domain
    organization = local.organization
  }
}

resource "tls_private_key" "domain_key" {
  algorithm = "RSA"
}

resource "tls_cert_request" "domain_csr" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.domain_key.private_key_pem

  dns_names = ["*.${var.domain}"]

  subject {
    common_name  = var.domain
    organization = local.organization
  }
}

resource "tls_locally_signed_cert" "domain_crt" {
  cert_request_pem = tls_cert_request.domain_csr.cert_request_pem

  ca_key_algorithm   = "RSA"
  ca_private_key_pem = tls_private_key.ca_key.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca_crt.cert_pem

  validity_period_hours = 87600
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
  ]
}

resource "local_file" "ca_crt" {
  content  = tls_self_signed_cert.ca_crt.cert_pem
  filename = "${path.module}/${local.ca_cert_path}"
}

resource "kubernetes_secret" "istio_tls" {
  metadata {
    name      = "istio-tls"
    namespace = kubernetes_namespace.istio_system.metadata[0].name
  }

  data = {
    "tls.crt" = tls_locally_signed_cert.domain_crt.cert_pem
    "tls.key" = tls_private_key.domain_key.private_key_pem
  }

  type = "kubernetes.io/tls"
}
