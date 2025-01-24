terraform {
  required_providers {
    minikube = {
      source = "scott-the-programmer/minikube"
      version = "0.4.4"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.35.1"
    }
    tls = {
      source = "hashicorp/tls"
      version = "3.1.0"
    }
  }
}

provider "minikube" {
  # Configuration options
}

provider "kubernetes" {
  host = minikube_cluster.cluster.host
  client_certificate = minikube_cluster.cluster.client_certificate
  client_key = minikube_cluster.cluster.client_key
  cluster_ca_certificate = minikube_cluster.cluster.cluster_ca_certificate
}


#--------------------------------------------------------------------------------------------------------------------------------------------------------------------

variable "namespaces" {
  type = list(string)
  description = "Kubernetes Namespaces"
  nullable = false
}

variable "app" {
  description = "App Definition"
  type = object({
    name = string
    replicas = map(number)
    image = string
    containerName = string
    port = number
  })
  nullable = false
}

resource "minikube_cluster" "cluster" {
  cluster_name = "terra-cluster"
  nodes = 1
}

resource "kubernetes_namespace" "environment" {
  for_each = toset(var.namespaces)
  metadata {
    name = each.key
  }
}

resource "kubernetes_deployment" "app" {
  for_each = toset(var.namespaces)
  metadata {
    name = "${var.app.name}-${each.key}"
    namespace = each.key
    labels = {
      app = "${var.app.name}-${each.key}"
    }
  }
  spec {
    replicas = var.app.replicas[each.key]
    selector {
      match_labels = {
        app = "${var.app.name}-${each.key}"
      }
    }
    template {
      metadata {
        labels = {
          app = "${var.app.name}-${each.key}"
        }
      }
      spec {
        container {
          image = var.app.image
          name  = var.app.containerName
          port {
            container_port = var.app.port
          }
        }
      }
    }
  }
}


#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Odoo Deployment
resource "kubernetes_deployment" "odoo" {
  metadata {
    name = "odoo"
    namespace = "prod"
    labels = {
      app = "odoo"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "odoo"
      }
    }
    template {
      metadata {
        labels = {
          app = "odoo"
        }
      }
      spec {
        container {
          image = "odoo:latest"
          name  = "odoo"
          port {
            container_port = 8069
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "odoo" {
  metadata {
    name = "odoo"
    namespace = "prod"
  }
  spec {
    selector = {
      app = "odoo"
    }
    port {
      port        = 80
      target_port = 8069
    }
  }
}



#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Ingress for HTTPS
resource "kubernetes_ingress_v1" "odoo" {
metadata {
    name = "odoo-ingress"
    namespace = "prod"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }
spec {
    tls {
      hosts      = ["odoo.example.com"]
      secret_name = "odoo-tls"
    }
    rule {
      host = "odoo.example.com"
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "odoo"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Self-Signed Certificate
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



#--------------------------------------------------------------------------------------------------------------------------------------------------------------------