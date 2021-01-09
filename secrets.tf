resource "kubernetes_secret" "this" {
  metadata {
    namespace = "kube-system"
    name = "logzio-logs-secret"
  }
  type = "Opaque"
  data = {
    "logzio-log-listener" = "https://${var.logzio_listener}:8071"
    "logzio-log-shipping-token" = var.logzio_token
  }
}