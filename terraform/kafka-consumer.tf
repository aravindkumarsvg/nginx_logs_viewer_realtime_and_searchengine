resource "kubernetes_deployment" "consumer-kafka" {
  metadata {
    name = "consumer-kafka"

    labels = {
      app = "consumer"
      env = "tuts"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "consumer"
        env = "tuts"
      }
    }

    template {
      metadata {
        labels = {
          app = "consumer"
          env = "tuts"
        }
      }

      spec {
        container = [
          {
            name  = "consumer-kafka"
            image = "${var.docker_images["kafka-consumer"]}"

            env = [
              {
                name  = "KAFKA_BROKER"
                value = "kafka-headless.default.svc.cluster.local:9092"
              },
              {
                name  = "KAFKA_CONSUMER_GROUP"
                value = "consumer-group"
              },
              {
                name  = "KAFKA_TOPIC"
                value = "nginx-access"
              },
              {
                name  = "MONGODB_HOST"
                value = "mongodb://mongodb-kafka-mongodb-replicaset-0.mongodb-kafka-mongodb-replicaset.default.svc.cluster.local:27017,mongodb-kafka-mongodb-replicaset-1.mongodb-kafka-mongodb-replicaset.default.svc.cluster.local:27017,mongodb-kafka-mongodb-replicaset-2.mongodb-kafka-mongodb-replicaset.default.svc.cluster.local:27017/?replicaSet=rs0"
              },
              {
                name  = "MONGODB_DB"
                value = "realtime"
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

  depends_on = ["helm_release.kafka", "helm_release.mongodb-kafka"]
}
