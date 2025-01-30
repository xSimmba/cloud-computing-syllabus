# PROVIDERS #
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
  host = minikube_cluster.client_name.host
  client_certificate = minikube_cluster.client_name.client_certificate
  client_key = minikube_cluster.client_name.client_key
  cluster_ca_certificate = minikube_cluster.client_name.cluster_ca_certificate
}
#--------------------------------------------------------------------------------#
