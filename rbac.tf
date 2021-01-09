resource "kubernetes_service_account" "this" {
  automount_service_account_token = "true"
  metadata {
    name      = "fluentd"
    namespace = "kube-system"
  }
}


resource "kubernetes_cluster_role" "this" {
  metadata {
    name = "fluentd"
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "namespaces"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "this" {
  metadata {
    name      = "fluentd"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.this.metadata.0.name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.this.metadata.0.name
    namespace = kubernetes_service_account.this.metadata.0.namespace
  }
}