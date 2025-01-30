# Odoo Deployment #
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
          #----------#
            env {
            name  = "DB_HOST"
            value = "postgres-db-service.prod.svc.cluster.local"  # PostgreSQL service in Kubernetes
          }
          env {
            name  = "DB_PORT"
            value = "5432"  # Default PostgreSQL port
          }
          env {
            name  = "DB_USER"
            value = "odoo_user"  # Your PostgreSQL user
          }
          env {
            name  = "DB_PASSWORD"
            value = "odoo_password"  # Your PostgreSQL password
          }
          env {
            name  = "DB_NAME"
            value = "odoo_db"  # Your PostgreSQL database name
          }
          #----------#
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

# PostgreSQL Service #
resource "kubernetes_service" "postgres" {
  metadata {
    name = "postgres-db-service"
    namespace = "prod"
  }
  spec {
    selector = {
      app = "postgres"
    }
    port {
      port        = 5432
      target_port = 5432
    }
  }
}

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
