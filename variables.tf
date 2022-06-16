locals {
  infix = "${var.purpose}-${var.environment}"
}

variable "subscription_id" {
  type = string
}
variable "client_id" {
  type = string
}
variable "client_secret" {
  type = string
}
variable "location" {}
variable "environment" {}
variable "purpose" {}

variable "network_cidrs" {
  default = {
    vnet   = "10.0.0.0/8"
    subnet = "10.1.0.0/16"
  }
  type = object({
    vnet   = string
    subnet = string
  })
}
variable "aks" {
  default = {
    kubernetes_version    = "1.22.4"
    availability_zones    = ["1", "2"]
    log_retention_in_days = 30
    ad_admin_group        = "5gadmin"
    node_pool = {
      node_count = 2
      vm_size    = "Standard_DS2_v2"
    }
  }

  type = object({
    // az aks get-versions --location westeurope -o table
    kubernetes_version    = string
    availability_zones    = list(string)
    log_retention_in_days = number
    ad_admin_group        = string
    node_pool = object({
      vm_size    = string
      node_count = number
    })
  })
}
variable "app" {
  type = object({
    namespace   = string
  })
  default = {
    namespace = "5gc-app"
  }
}

variable "dns" {
  type = object({
    domain   = string
    prefix    = string
  })
  default = {
    domain = "5g-demo.info"
    prefix = "amdocs1"
  }
}