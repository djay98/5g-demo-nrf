resource "helm_release" "health-app" {
  namespace  = "${var.app.namespace}-ns"
  name       = "health-app"
  chart      = "${path.root}/helm/helm-health"
}


resource "kubernetes_ingress_v1" "health-ingress" {
  metadata {
    namespace  = "${var.app.namespace}-ns"
    name       = "health-ingress"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "false"
      "cert-manager.io/cluster-issuer" = "letsencrypt-prod"
    }
  }
  spec {
    rule {
      host = "health.${var.dnsprefix}.${var.dnsdomain}"
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "health-app-service"
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
        "health.${var.dnsprefix}.${var.dnsdomain}"
      ]
      secret_name = "health-tls-secret"
    }
  }
}