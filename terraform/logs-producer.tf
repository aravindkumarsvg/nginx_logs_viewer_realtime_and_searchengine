resource "kubernetes_deployment" "nginx-logs-producer" {
  metadata {
    name = "nginx-logs-producer"

    labels = {
      app = "nginx"
      env = "tuts"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nginx"
        env = "tuts"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
          env = "tuts"
        }
      }

      spec {
        volume = [
          {
            name      = "nginx-logs"
            empty_dir = {}
          },
        ]

        container = [
          {
            name  = "nginx"
            image = "${var.docker_images["nginx"]}"

            port = [
              {
                container_port = 80
              },
            ]

            volume_mount = [
              {
                name       = "nginx-logs"
                mount_path = "/var/log/nginx"
              },
            ]
          },
          {
            name  = "nginx-fluentd"
            image = "${var.docker_images["nginx-fluentd"]}"

            env = [
              {
                name  = "KAFKA_BROKER"
                value = "kafka-headless.default.svc.cluster.local:9092"
              },
              {
                name  = "KAFKA_TOPIC"
                value = "nginx-access"
              },
              {
                name  = "ELASTICSEARCH_HOST"
                value = "elasticsearch.default.svc.cluster.local"
              },
              {
                name  = "ELASTICSEARCH_PORT"
                value = "9200"
              },
            ]

            volume_mount = [
              {
                name       = "nginx-logs"
                mount_path = "/nginx-logs"
              },
            ]
          },
        ]
      }
    }
  }

  depends_on = ["kubernetes_service.elasticsearch", "helm_release.kafka"]
}

resource "kubernetes_service" "nginx-logs-producer" {
  metadata {
    labels = {
      app = "nginx"
      env = "tuts"
    }

    name = "nginx-logs-producer"
  }

  spec {
    type = "NodePort"

    selector {
      app = "nginx"
      env = "tuts"
    }

    port = [
      {
        port        = 8080
        protocol    = "TCP"
        target_port = 80
      },
    ]
  }

  depends_on = ["kubernetes_deployment.nginx-logs-producer"]
}

output "logs_producer_url" {
  value = "http://<minikube ip>:${kubernetes_service.nginx-logs-producer.spec.0.port.0.node_port}"
}
