resource "kubernetes_deployment" "realtime-viewer-kafka" {
  metadata {
    name = "realtime-viewer-kafka"

    labels = {
      app = "realtime-viewer"
      env = "tuts"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "realtime-viewer"
        env = "tuts"
      }
    }

    template {
      metadata {
        labels = {
          app = "realtime-viewer"
          env = "tuts"
        }
      }

      spec {
        container = [
          {
            name  = "realtime-viewer"
            image = "${var.docker_images["realtime-viewer"]}"

            port = [
              {
                container_port = 3000
              },
            ]

            env = [
              {
                name  = "MONGODB_URI"
                value = "mongodb://mongodb-kafka-mongodb-replicaset-0.mongodb-kafka-mongodb-replicaset.default.svc.cluster.local:27017,mongodb-kafka-mongodb-replicaset-1.mongodb-kafka-mongodb-replicaset.default.svc.cluster.local:27017,mongodb-kafka-mongodb-replicaset-2.mongodb-kafka-mongodb-replicaset.default.svc.cluster.local:27017/realtime?replicaSet=rs0"
              },
              {
                name  = "MONGODB_COLLECTION"
                value = "nginx-access"
              },
            ]
          },
        ]
      }
    }
  }

  depends_on = ["helm_release.mongodb-kafka"]
}

resource "kubernetes_service" "realtime-viewer" {
  metadata {
    labels = {
      app = "realtime-viewer"
      env = "tuts"
    }

    name = "realtime-viewer"
  }

  spec {
    type = "NodePort"

    selector {
      app = "realtime-viewer"
    }

    port = [
      {
        port        = 3000
        protocol    = "TCP"
        target_port = 3000
      },
    ]
  }

  depends_on = ["kubernetes_deployment.realtime-viewer-kafka"]
}

output "realtime_viewer_url" {
  value = "http://<minikube ip>:${kubernetes_service.realtime-viewer.spec.0.port.0.node_port}"
}
