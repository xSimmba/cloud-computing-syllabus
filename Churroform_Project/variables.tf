

variable "client_name" {
  description = "Client Name to create cluster"
  type = object({
    name = string
  })
  nullable = false
}

variable "Clusterize"  {
  type = object({
    name = string
    nodes = number
    addons = list(string)
  })
}
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