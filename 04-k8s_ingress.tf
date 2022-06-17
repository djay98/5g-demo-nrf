
resource "kubernetes_ingress_v1" "app-5g-nrf-ingress" {
  metadata {
    namespace  = "${var.app.namespace}-ns"
    name       = "nrf-ingress"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "false"
      "cert-manager.io/cluster-issuer" = "letsencrypt-prod"
      "nginx.ingress.kubernetes.io/enable-cors": "true"
      "nginx.ingress.kubernetes.io/cors-allow-origin" = "https://amdocs-swagger.5g-demo.info"
    }
  }
  spec {
    rule {
      host = "nrf000.${var.dnsprefix}.${var.dnsdomain}"
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "nrf-nnrf"
              port {
                number = 8000
              }
            }
          }
        }
      }
    }
    tls {
      hosts = [
        "nrf000.${var.dnsprefix}.${var.dnsdomain}"
      ]
      secret_name = "nrf-tls-secret"
    }
  }
}

resource "kubernetes_ingress_v1" "app-5g-pcf-ingress" {
  metadata {
    namespace  = "${var.app.namespace}-ns"
    name       = "pcf-ingress"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "false"
      "cert-manager.io/cluster-issuer" = "letsencrypt-prod"
      "nginx.ingress.kubernetes.io/enable-cors": "true"
      "nginx.ingress.kubernetes.io/cors-allow-origin" = "https://amdocs-swagger.5g-demo.info"
    }
  }
  spec {
    rule {
      host = "pcf000.${var.dnsprefix}.${var.dnsdomain}"
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "pcf-npcf"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
    tls {
      hosts = [
        "pcf000.${var.dnsprefix}.${var.dnsdomain}"
      ]
      secret_name = "pcf-tls-secret"
    }
  }
}

