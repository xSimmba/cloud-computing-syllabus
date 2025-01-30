
client_name = {
  name = "Rockstar"
}
Clusterize = {
  name = "Rockstar"
  nodes = 3
  addons = [ "ingress" ]
}

namespaces = ["dev", "qa", "prod"]

app = {
  containerName = "container-rockstar"
  image = "nginx:alpine"
  name = "rockstar"
  port = 80
  replicas = {
    dev  = 3
    qa   = 6
    prod = 9
  }
}