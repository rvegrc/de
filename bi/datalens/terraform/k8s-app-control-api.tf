resource "kubernetes_deployment" "control-api" {
  for_each = toset(local.k8s_cluster_ready ? ["main"] : [])

  metadata {
    name      = "control-api"
    namespace = kubernetes_namespace.this.metadata[0].name
    labels = {
      app = "app-control-api"
    }
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "app-control-api"
      }
    }
    template {
      metadata {
        labels = {
          app = "app-control-api"
        }
      }
      spec {
        container {
          image = "ghcr.io/datalens-tech/datalens-control-api:${local.backend_version}"
          name  = "app-control-api"
          port {
            container_port = 8080
          }

          liveness_probe {
            http_get {
              path = "/ping"
              port = 8080
            }

            initial_delay_seconds = 3
            period_seconds        = 5
            timeout_seconds       = 10

            success_threshold = 1
            failure_threshold = 3
          }

          resources {
            limits = {
              memory = "1024Mi"
            }
            requests = {
              cpu    = "0.5"
              memory = "512Mi"
            }
          }
          env {
            name  = "BI_API_UWSGI_WORKERS_COUNT"
            value = "3"
          }
          env {
            name  = "CONNECTOR_AVAILABILITY_VISIBLE"
            value = "clickhouse,postgres,chyt,ydb,mysql,greenplum,mssql,oracle,trino,appmetrica_api,metrika_api"
          }
          env {
            name  = "RQE_FORCE_OFF"
            value = "1"
          }
          env {
            name  = "DL_CRY_ACTUAL_KEY_ID"
            value = "KEY"
          }
          env {
            name = "DL_CRY_KEY_VAL_ID_KEY"
            value_from {
              secret_key_ref {
                name = "k8s-lockbox-secret"
                key  = "CONTROL_API_CRYPTO_KEY"
              }
            }
          }
          env {
            name  = "RQE_SECRET_KEY"
            value = ""
          }
          env {
            name  = "US_HOST"
            value = "http://us-cip:8080"
          }
          env {
            name = "US_MASTER_TOKEN"
            value_from {
              secret_key_ref {
                name = "k8s-lockbox-secret"
                key  = "US_MASTER_TOKEN"
              }
            }
          }
          env {
            name  = "AUTH__TYPE"
            value = "NATIVE"
          }
          env {
            name  = "AUTH__JWT_ALGORITHM"
            value = "PS256"
          }
          env {
            name = "AUTH__JWT_KEY"
            value_from {
              secret_key_ref {
                name = "k8s-lockbox-secret"
                key  = "AUTH_TOKEN_PUBLIC_KEY"
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "control-api_service" {
  for_each = toset(local.k8s_cluster_ready ? ["main"] : [])

  metadata {
    name      = "control-api-cip"
    namespace = kubernetes_namespace.this.metadata[0].name
  }
  spec {
    selector = {
      app = "app-control-api"
    }
    port {
      name        = "http"
      port        = 8080
      target_port = 8080
      protocol    = "TCP"
    }
    type = "ClusterIP"
  }
}
