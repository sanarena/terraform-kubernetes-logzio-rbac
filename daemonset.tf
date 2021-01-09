resource "kubernetes_daemonset" "this" {
  metadata {
    name      = "fluentd-logzio"
    namespace = "kube-system"

    labels = {
      "k8s-app" = "fluentd-logzio"
      "version" = "1"
    }
  }

  spec {
    selector {
      match_labels = {
        "k8s-app" = "fluentd-logzio"
      }
    }

    template {
      metadata {
        labels = {
          "k8s-app" = "fluentd-logzio"
        }

        # annotations = {
        # }
      }

      spec {

        termination_grace_period_seconds = 30
        service_account_name = kubernetes_service_account.this.metadata.0.name
        automount_service_account_token = true
        
        toleration {
          effect = "NoSchedule"
          key = "onlyfor"
          operator = "Equal"
          value = "highcpu"
        }
        toleration {
          effect = "NoSchedule"
          key = "dbonly"
          operator = "Equal"
          value = "yes"
        }
        toleration {
          effect = "NoSchedule"
          key = "node-role.kubernetes.io/master"
        }

        container {
          name  = "fluentd"
          image = "logzio/logzio-k8s:1.1.6"

          env {
            name = "LOGZIO_LOG_SHIPPING_TOKEN"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.this.metadata.0.name
                key = "logzio-log-shipping-token"
              }
            }
          }

          env {
            name = "LOGZIO_LOG_LISTENER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.this.metadata.0.name
                key = "logzio-log-listener"
              }
            }
          }

          env {
            name = "FLUENTD_SYSTEMD_CONF"
            value = "disable"
          }

          env {
            name = "FLUENTD_PROMETHEUS_CONF"
            value = "disable"
          }

          env {
            name = "INCLUDE_NAMESPACE"
            value = ""
          }

          env {
            name = "KUBERNETES_VERIFY_SSL"
            value = "false"
          }

          resources {
            limits {
              memory = "200Mi"
            }
            requests {
              cpu = "100m"
              memory = "200Mi"
            }
          }

          volume_mount {
            name = "varlog"
            mount_path = "/var/log"
          }

          volume_mount {
            name = "varlibdockercontainers"
            mount_path = "/var/lib/docker/containers"
            read_only = true
          }

        }


        volume {
          name = "varlog"
          host_path {
            path = "/var/log"
          }
        }
        volume {
          name = "varlibdockercontainers"
          host_path {
            path = "/var/lib/docker/containers"
          }
        }

      }
    }
  }
}
