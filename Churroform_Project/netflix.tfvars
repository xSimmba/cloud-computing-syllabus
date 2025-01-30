client_name = {
  name = "Netflix"
}
Clusterize = {
  name = "Netflix"
  nodes = 1
  addons = [ "ingress" ]
}


namespaces = ["dev", "qa", "prod"]

app = {
  containerName = "container-netflix"
  image = "nginx:alpine"
  name = "netflix"
  port = 80
  replicas = {
    dev  = 1
    qa   = 2
    prod = 3
  }
}
