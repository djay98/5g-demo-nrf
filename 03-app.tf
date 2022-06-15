resource "kubernetes_namespace" "app_ns" {
  metadata {
    name = "${var.app.namespace}-ns"
  }
}

resource "helm_release" "app-5g-nrf" {
  namespace  = "${var.app.namespace}-ns"
  name       = "${var.app.name}-app"
  chart      = "${path.root}/helm/free5gc"

  depends_on = [
      kubernetes_namespace.app_ns,
  ]
}

