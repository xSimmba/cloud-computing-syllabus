resource "tls_private_key" "example" {
  algorithm = "ECDSA"
}

resource "tls_self_signed_cert" "example" {
  key_algorithm   = tls_private_key.example.algorithm
  private_key_pem = tls_private_key.example.private_key_pem

  validity_period_hours = 8760  # 1 year
  early_renewal_hours   = 720   # 1 month

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]

  dns_names = ["odoo.example.com"]

  subject {
    common_name  = "odoo.example.com"
    organization = "Your Organization"
  }
}

#Odoo TLS#
resource "kubernetes_secret" "odoo_tls" {
  metadata {
    name = "odoo-tls"
    namespace = "prod"
  }
  data = {
    "tls.crt" = tls_self_signed_cert.example.cert_pem
    "tls.key" = tls_private_key.example.private_key_pem
  }
}