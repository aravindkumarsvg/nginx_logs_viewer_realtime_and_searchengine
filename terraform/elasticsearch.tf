resource "kubernetes_deployment" "elasticsearch" {
  metadata {
    name = "elasticsearch"

    labels = {
      app = "elasticsearch"
      env = "tuts"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "elasticsearch"
        env = "tuts"
      }
    }

    template {
      metadata {
        labels = {
          app = "elasticsearch"
          env = "tuts"
        }
      }

      spec {
        container = [
          {
            name  = "elasticsearch"
            image = "elasticsearch:7.2.0"

            env = [
              {
                name  = "discovery.type"
                value = "single-node"
              },
            ]

            port = [
              {
                container_port = 9200
              },
              {
                container_port = 9300
              },
            ]
          },
        ]
      }
    }
  }
}

resource "kubernetes_service" "elasticsearch" {
  metadata {
    labels = {
      app = "elasticsearch"
      env = "tuts"
    }

    name = "elasticsearch"
  }

  spec {
    type = "ClusterIP"

    selector {
      app = "elasticsearch"
    }

    port = [
      {
        port        = 9200
        protocol    = "TCP"
        target_port = 9200
        name        = "api"
      },
      {
        port        = 9300
        protocol    = "TCP"
        target_port = 9300
        name        = "alternate"
      },
    ]
  }

  depends_on = ["kubernetes_deployment.elasticsearch"]
}
