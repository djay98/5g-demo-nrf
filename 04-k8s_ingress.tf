
resource "kubernetes_ingress_v1" "app-5g-nrf-ingress" {
  metadata {
    namespace  = "${var.app.namespace}-ns"
    name       = "${var.app.name}-ingress"
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
      host = "${var.app.name}.${var.dns.child}.${var.dns.domain}"
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
        "${var.app.name}.${var.dns.child}.${var.dns.domain}"
      ]
      secret_name = "${var.app.name}-tls-secret"
    }
  }
}

