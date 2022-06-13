resource "helm_release" "nrfhealth-app" {
  namespace  = "${var.app.namespace}-ns"
  name       = "nrfhealth-app"
  chart      = "${path.root}/helm/helm-nrf-health"
}


resource "kubernetes_ingress_v1" "nrfhealth-ingress" {
  metadata {
    namespace  = "${var.app.namespace}-ns"
    name       = "nrfhealth-ingress"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "false"
      "cert-manager.io/cluster-issuer" = "letsencrypt-prod"
    }
  }
  spec {
    rule {
      host = "nrfhealth.${var.dns.child}.${var.dns.domain}"
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "nrfhealth-app-service"
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
        "nrfhealth.${var.dns.child}.${var.dns.domain}"
      ]
      secret_name = "nrfhealth-tls-secret"
    }
  }
}