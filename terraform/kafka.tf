resource "helm_release" "kafka" {
    name = "kafka"
    chart = "bitnami/kafka"
    repository = "${data.helm_repository.bitnami.metadata.0.name}"
}
