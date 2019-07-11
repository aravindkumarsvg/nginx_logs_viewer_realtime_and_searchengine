# terraform configurations
terraform {
  backend "consul" {
    address = "172.17.0.2:8500"
    scheme  = "http"
    path    = "realtime-nginx"
  }
}

# Helm repositories
data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}

data "helm_repository" "bitnami" {
  name = "bitnami"
  url  = "https://charts.bitnami.com/bitnami"
}

# Provider configurations
provider kubernetes {
  host = "https://192.168.99.100:8443"

  client_certificate     = "${file("/home/aravind/.minikube/client.crt")}"
  client_key             = "${file("/home/aravind/.minikube/client.key")}"
  cluster_ca_certificate = "${file("/home/aravind/.minikube/ca.crt")}"
}

provider helm {
  kubernetes {
    host = "https://192.168.99.100:8443"

    client_certificate     = "${file("/home/aravind/.minikube/client.crt")}"
    client_key             = "${file("/home/aravind/.minikube/client.key")}"
    cluster_ca_certificate = "${file("/home/aravind/.minikube/ca.crt")}"
  }
}
