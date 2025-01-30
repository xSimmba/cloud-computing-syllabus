
resource "minikube_cluster" "client_name" {
  cluster_name = var.Clusterize.name
  nodes = var.Clusterize.nodes
  addons = var.Clusterize.addons

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
